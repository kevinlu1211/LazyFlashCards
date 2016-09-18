//
//  SampleTableViewController.swift
//  AEAccordion
//
//  Created by Marko Tadic on 6/26/15.
//  Copyright © 2015 AE. All rights reserved.
//

import UIKit
import LiquidFloatingActionButton
import PopupDialog
import HidingNavigationBar
import AEAccordion
import AEXibceptionView
import CoreData

class ViewDecksController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    
    private let cellIdentifier = "DeckTableViewCell"
    private let ADD_DECK_BUTTON_INDEX = 0
    var liquidFloatingCells: [LiquidFloatingCell] = []
    var tableView: UITableView!
    
    // Core Data
    private var decks = [Deck]()
    lazy var sharedContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var theme : ThemeStrategy {
        return ThemeFactory.sharedInstance().getTheme()
    }
    
    /// Array of `NSIndexPath` objects for all of the expanded cells.
    internal var expandedIndexPaths = [NSIndexPath]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Decks"
        
        // Setup Theme
        
        // Setup Tab
        tableViewSetup()
        expandFirstCell()
        liquidButtonSetup()
        decks = fetchAllDecks()
        
        if let navController = navigationController {
            styleNavigationController(navController)
        }
    }

    func styleNavigationController(navigationController: UINavigationController){
        navigationController.navigationBar.translucent = false
        navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController.navigationBar.tintColor = UIColor.whiteColor()
        navigationController.navigationBar.barTintColor = theme.getDarkColor()
    }

}

// MARK: - Core Data

extension ViewDecksController {
    func fetchAllDecks() -> [Deck] {
        let fetchRequest = NSFetchRequest(entityName: "Deck")
        do {
            let decks = try sharedContext.executeFetchRequest(fetchRequest) as! [Deck]
            return decks
        }
        catch {
            print("Error")
            return [Deck]()
        }
    }
}


// MARK: - UITableView methods

extension ViewDecksController {
    
    // MARK: - Helpers
    
    func tableViewSetup() {
        tableView = UITableView(frame: view.bounds)
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        self.tableView.separatorStyle = .None
        registerCell()
        tableView.reloadData()
        tableView.backgroundColor = theme.getDarkColor()
    }
    func registerCell() {
        let cellNib = UINib(nibName: cellIdentifier, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: cellIdentifier)
    }
    
    func expandFirstCell() {
        let firstCellIndexPath = NSIndexPath(forRow: 0, inSection: 0)
        expandedIndexPaths.append(firstCellIndexPath)
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return decks.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! DeckTableViewCell
      
        
        // Setup header view
        cell.headerView.titleLabel.text = decks[indexPath.row].name
        cell.detailView.delegate = self
        
        cell.setup()
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return expandedIndexPaths.contains(indexPath) ? 200.0 : 50.0
    }
    

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = cell as? AEAccordionTableViewCell {
            let expanded = expandedIndexPaths.contains(indexPath)
            cell.setExpanded(expanded, animated: false)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? AEAccordionTableViewCell {
            toggleCell(cell, animated: true)
        }
    }
    
    func toggleCell(cell: AEAccordionTableViewCell, animated: Bool) {
        if !cell.expanded {
            expandCell(cell, animated: animated)
        } else {
            collapseCell(cell, animated: animated)
        }
    }
    
    
}

// MARK: - Helpers
// TODO: - Separate this out into another class
extension ViewDecksController {
    
    private func expandCell(cell: AEAccordionTableViewCell, animated: Bool) {
        if let indexPath = tableView.indexPathForCell(cell) {
            if !animated {
                cell.setExpanded(true, animated: false)
                addToExpandedIndexPaths(indexPath)
            } else {
                CATransaction.begin()
                
                CATransaction.setCompletionBlock({ () -> Void in
                    // 2. animate views after expanding
                    cell.setExpanded(true, animated: true)
                })
                
                // 1. expand cell height
                tableView.beginUpdates()
                addToExpandedIndexPaths(indexPath)
                tableView.endUpdates()
                
                CATransaction.commit()
            }
        }
    }
    
    private func collapseCell(cell: AEAccordionTableViewCell, animated: Bool) {
        if let indexPath = tableView.indexPathForCell(cell) {
            if !animated {
                cell.setExpanded(false, animated: false)
                removeFromExpandedIndexPaths(indexPath)
            } else {
                CATransaction.begin()
                
                CATransaction.setCompletionBlock({ () -> Void in
                    // 2. collapse cell height
                    self.tableView.beginUpdates()
                    self.removeFromExpandedIndexPaths(indexPath)
                    self.tableView.endUpdates()
                })
                
                // 1. animate views before collapsing
                cell.setExpanded(false, animated: true)
                
                CATransaction.commit()
            }
        }
    }
    
    private func addToExpandedIndexPaths(indexPath: NSIndexPath) {
        expandedIndexPaths.append(indexPath)
    }
    
    private func removeFromExpandedIndexPaths(indexPath: NSIndexPath) {
        if let index = self.expandedIndexPaths.indexOf(indexPath) {
            self.expandedIndexPaths.removeAtIndex(index)
        }
    }

}

extension ViewDecksController : LiquidFloatingActionButtonDataSource, LiquidFloatingActionButtonDelegate{
    func liquidButtonSetup () {
        
        let createButton: (CGRect, LiquidFloatingActionButtonAnimateStyle) -> LiquidFloatingActionButton = { (frame, style) in
            let floatingActionButton = CustomDrawingActionButton(frame: frame)
            floatingActionButton.animateStyle = style
            floatingActionButton.dataSource = self
            floatingActionButton.delegate = self
            return floatingActionButton
        }
        
        let customCellFactory: (String, String) -> LiquidFloatingCell = { (iconName, iconLabel) in
            let cell = CustomCell(icon: UIImage(named: iconName)!, name: iconLabel)
            return cell
        }
        
        
        // Setup bottom right button
        liquidFloatingCells.append(customCellFactory("ic_brush", "Add Deck"))
        
        // Setup the frame 
        
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        let navigationBarHeight = self.navigationController!.navigationBar.frame.height
        let buttonHeight = CGFloat(56)
        let floatingFrame = CGRect(x: 0, y: 0 , width: buttonHeight, height: buttonHeight)
        let bottomRightButton = createButton(floatingFrame, .Up)
        let image = UIImage(named: "ic_add_circle_outline_white")
        bottomRightButton.image = image
        bottomRightButton.backgroundColor = theme.getDarkColor()

        self.view.addSubview(bottomRightButton)
//        bottomRightButton.center = CGPointMake(self.view.bounds.width - 56 - 16, self.view.bounds.height - 56 - 16 - statusBarHeight - navigationBarHeight)
        bottomRightButton.center = CGPointMake(self.view.bounds.width - buttonHeight, self.view.bounds.height - buttonHeight - statusBarHeight - navigationBarHeight)
    
    }
    
    func numberOfCells(liquidFloatingActionButton: LiquidFloatingActionButton) -> Int {
        return liquidFloatingCells.count
    }
    
    func cellForIndex(index: Int) -> LiquidFloatingCell {
        return liquidFloatingCells[index]
    }
    
    func liquidFloatingActionButton(liquidFloatingActionButton: LiquidFloatingActionButton, didSelectItemAtIndex index: Int) {
        print("did Tapped! \(index)")
        if index == ADD_DECK_BUTTON_INDEX {
            deckSetupPopup()
        }
        liquidFloatingActionButton.close()
    }
    
    func deckSetupPopup() {
        let deckSetupVC = AddDeckViewController(nibName: "AddDeckViewController", bundle: nil)
        let popup = PopupDialog(viewController: deckSetupVC, transitionStyle: .BounceDown, buttonAlignment: .Horizontal, gestureDismissal: true)
        deckSetupVC.delegate = self
        presentViewController(popup, animated: true, completion: nil)
        
    }
    
}
extension ViewDecksController : DetailDeckViewDelegate {
    func handleViewDeck(detailDeckView: DetailDeckView) {
        let detailDeckViewController = self.storyboard?.instantiateViewControllerWithIdentifier("DetailDeckViewController") as! DetailDeckViewController
        let indexPath = tableView.indexPathForCell(detailDeckView.getParentTableViewCell())
        if let indexPath = indexPath {
            detailDeckViewController.deck = decks[indexPath.row]
        }
        self.navigationController!.pushViewController(detailDeckViewController, animated: true)

        print("handled the button woohoo")
    }
    
    func handleTest(detailDeckView: DetailDeckView) {
        let testViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TestViewController") as! TestViewController
        let indexPath = tableView.indexPathForCell(detailDeckView.getParentTableViewCell())
        if let indexPath = indexPath {
            testViewController.deck = decks[indexPath.row]
        }

        self.navigationController!.pushViewController(testViewController, animated: true)
    }
    
    func handleSettings(detailDeckView: DetailDeckView) {
        // Setup the delete deck view controller
        let settingsViewController = SettingsViewController(nibName: "SettingsViewController", bundle: nil)
        let indexPathOfDeck = tableView.indexPathForCell(detailDeckView.getParentTableViewCell())
        if let indexPath = indexPathOfDeck {
            let deck = decks[indexPath.row]
            settingsViewController.deleteDeck = deleteDeckHandler
            settingsViewController.changeDeckName = changeDeckNameHandler
            settingsViewController.deck = deck
            settingsViewController.indexPathOfDeck = indexPath
            let popup = PopupDialog(viewController: settingsViewController, transitionStyle: .BounceDown, buttonAlignment: .Horizontal, gestureDismissal: true)
            presentViewController(popup, animated: true, completion: nil)

        }
    }
    
    func deleteDeckHandler(indexPathOfDeck : NSIndexPath) {
        
    
        // Get the deck that is to be deleted
        let deck = decks[indexPathOfDeck.row]
        
        // Update data source and table
        decks.removeAtIndex(indexPathOfDeck.row)
        tableView.deleteRowsAtIndexPaths([indexPathOfDeck], withRowAnimation: .Fade)
        removeFromExpandedIndexPaths(indexPathOfDeck)
        
        // Delete flashCard instance by setting it to nil
        deck.flashCards = nil
        sharedContext.deleteObject(deck)
        CoreDataStackManager.sharedInstance().saveContext()
        
        
        self.dismissViewControllerAnimated(false, completion: nil)

    }
    
    func changeDeckNameHandler(newDeckName: String, indexPathOfDeck: NSIndexPath) {
       
        let deck = decks[indexPathOfDeck.row]
        deck.name = newDeckName
        print(deck.name)
        tableView.reloadRowsAtIndexPaths([indexPathOfDeck], withRowAnimation: .Fade)
        CoreDataStackManager.sharedInstance().saveContext()
        self.dismissViewControllerAnimated(false, completion: nil)
        
        
    }
    


}


extension ViewDecksController : AddDeckViewControllerDelegate {
    func handleAddDeck(deckName : String) {
        // First add the things required to update the data source
        let deck = Deck(context: sharedContext, name: deckName, detail: nil)
        decks.append(deck)
        
        // Save it to CoreData
        CoreDataStackManager.sharedInstance().saveContext()
        
        // Reload the tableView
        tableView.reloadData()
        
        // Now dismiss the popup view controller
        self.dismissViewControllerAnimated(false, completion: nil)
    }
}

