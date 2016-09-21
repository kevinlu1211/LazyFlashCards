//
//  ViewDecksController.swift
//
//
//  Created by Kevin Lu on 21/08/2016.
//
//

import UIKit
import LiquidFloatingActionButton
import PopupDialog
import AEAccordion
import AEXibceptionView
import CoreData

class ViewDecksController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties

    fileprivate let cellIdentifier = "DeckTableViewCell"
    fileprivate let ADD_DECK_BUTTON_INDEX = 0
    var liquidFloatingCells: [LiquidFloatingCell] = []
    var tableView: UITableView!
    
    // Core Data
    fileprivate var decks = [Deck]()
    lazy var sharedContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var theme : ThemeStrategy {
        return ThemeFactory.sharedInstance().getTheme()
    }
    
    /// Array of `NSIndexPath` objects for all of the expanded cells.
    internal var expandedIndexPaths = [IndexPath]()
    
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

    func styleNavigationController(_ navigationController: UINavigationController){
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController.navigationBar.tintColor = UIColor.white
        navigationController.navigationBar.barTintColor = theme.getDarkColor()
    }

}

// MARK: - Core Data

extension ViewDecksController {
    func fetchAllDecks() -> [Deck] {
        do {
            let decks = try sharedContext.fetch(NSFetchRequest(entityName: "Deck"))
            return decks as! [Deck]
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
        self.tableView.separatorStyle = .none
        registerCell()
        tableView.reloadData()
        tableView.backgroundColor = theme.getDarkColor()
    }
    func registerCell() {
        let cellNib = UINib(nibName: cellIdentifier, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
    }
    
    func expandFirstCell() {
        let firstCellIndexPath = IndexPath(row: 0, section: 0)
        expandedIndexPaths.append(firstCellIndexPath)
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return decks.count
    }
    
    @objc(tableView:cellForRowAtIndexPath:) func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! DeckTableViewCell
      
        
        // Setup header view
        cell.headerView.titleLabel.text = decks[(indexPath as NSIndexPath).row].name
        cell.detailView.delegate = self
        
        cell.setup()
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    @objc(tableView:heightForRowAtIndexPath:) func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return expandedIndexPaths.contains(indexPath) ? 200.0 : 50.0
    }
    

    @objc(tableView:willDisplayCell:forRowAtIndexPath:) func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? AEAccordionTableViewCell {
            let expanded = expandedIndexPaths.contains(indexPath)
            cell.setExpanded(expanded, animated: false)
        }
    }
    
    @objc(tableView:didSelectRowAtIndexPath:) func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? AEAccordionTableViewCell {
            toggleCell(cell, animated: true)
        }
    }
    
    func toggleCell(_ cell: AEAccordionTableViewCell, animated: Bool) {
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
    
    fileprivate func expandCell(_ cell: AEAccordionTableViewCell, animated: Bool) {
        if let indexPath = tableView.indexPath(for: cell) {
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
    
    fileprivate func collapseCell(_ cell: AEAccordionTableViewCell, animated: Bool) {
        if let indexPath = tableView.indexPath(for: cell) {
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
    
    fileprivate func addToExpandedIndexPaths(_ indexPath: IndexPath) {
        expandedIndexPaths.append(indexPath)
    }
    
    fileprivate func removeFromExpandedIndexPaths(_ indexPath: IndexPath) {
        if let index = self.expandedIndexPaths.index(of: indexPath) {
            self.expandedIndexPaths.remove(at: index)
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
        liquidFloatingCells.append(customCellFactory(ImageName.ADD_DECK_IMAGE_NAME, "Add Deck"))
        
        // Setup the frame of the expanding button on the bottom right
        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        let navigationBarHeight = self.navigationController!.navigationBar.frame.height
        let buttonHeight = CGFloat(56)
        let floatingFrame = CGRect(x: 0, y: 0 , width: buttonHeight, height: buttonHeight)
        let bottomRightButton = createButton(floatingFrame, .up)
        self.view.addSubview(bottomRightButton)
        bottomRightButton.center = CGPoint(x: self.view.bounds.width - buttonHeight, y: self.view.bounds.height - buttonHeight - statusBarHeight - navigationBarHeight)
        
        // Setup the image of the expanding button
        let image = UIImage(named: ImageName.EXPANDING_MENU_IMAGE_IMAGE)
        bottomRightButton.image = image
        bottomRightButton.backgroundColor = UIColor.clear
        bottomRightButton.color = theme.getContrastColor()

    
    }
    
    func numberOfCells(_ liquidFloatingActionButton: LiquidFloatingActionButton) -> Int {
        return liquidFloatingCells.count
    }
    
    func cellForIndex(_ index: Int) -> LiquidFloatingCell {
        return liquidFloatingCells[index]
    }
    
    func liquidFloatingActionButton(_ liquidFloatingActionButton: LiquidFloatingActionButton, didSelectItemAtIndex index: Int) {
        print("did Tapped! \(index)")
        if index == ADD_DECK_BUTTON_INDEX {
            deckSetupPopup()
        }
        liquidFloatingActionButton.close()
    }
    
    func deckSetupPopup() {
        let deckSetupVC = AddDeckViewController(nibName: "AddDeckViewController", bundle: nil)
        let popup = PopupDialog(viewController: deckSetupVC, buttonAlignment: .horizontal, transitionStyle: .bounceDown, gestureDismissal: true)
        deckSetupVC.delegate = self
        present(popup, animated: true, completion: nil)
        
    }
    
}
extension ViewDecksController : DetailDeckViewDelegate {
    func handleViewDeck(_ detailDeckView: DetailDeckView) {
        let detailDeckViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailDeckViewController") as! DetailDeckViewController
        let indexPath = tableView.indexPath(for: detailDeckView.getParentTableViewCell())
        if let indexPath = indexPath {
            detailDeckViewController.deck = decks[(indexPath as NSIndexPath).row]
        }
        self.navigationController!.pushViewController(detailDeckViewController, animated: true)

        print("handled the button woohoo")
    }
    
    func handleTest(_ detailDeckView: DetailDeckView) {
        let testViewController = self.storyboard?.instantiateViewController(withIdentifier: "TestViewController") as! TestViewController
        let indexPath = tableView.indexPath(for: detailDeckView.getParentTableViewCell())
        if let indexPath = indexPath {
            testViewController.deck = decks[(indexPath as NSIndexPath).row]
        }

        self.navigationController!.pushViewController(testViewController, animated: true)
    }
    
    func handleSettings(_ detailDeckView: DetailDeckView) {
        // Setup the delete deck view controller
        let settingsViewController = SettingsViewController(nibName: "SettingsViewController", bundle: nil)
        let indexPathOfDeck = tableView.indexPath(for: detailDeckView.getParentTableViewCell())
        if let indexPath = indexPathOfDeck {
            let deck = decks[(indexPath as NSIndexPath).row]
//            settingsViewController.deleteDeck = deleteDeckHandler
//            settingsViewController.changeDeckName = changeDeckNameHandler
            settingsViewController.delegate = self
            settingsViewController.deck = deck
            settingsViewController.indexPathOfDeck = indexPath
            let popup = PopupDialog(viewController: settingsViewController, buttonAlignment: .horizontal, transitionStyle: .bounceDown,  gestureDismissal: true)
            present(popup, animated: true, completion: nil)

        }
    }
    
    func deleteDeckHandler(_ indexPathOfDeck : IndexPath) {
        
    
        // Get the deck that is to be deleted
        let deck = decks[(indexPathOfDeck as NSIndexPath).row]
        
        // Update data source and table
        decks.remove(at: (indexPathOfDeck as NSIndexPath).row)
        tableView.deleteRows(at: [indexPathOfDeck], with: .fade)
        removeFromExpandedIndexPaths(indexPathOfDeck)
        
        // Delete flashCard instance by setting it to nil
        deck.flashCards = nil
        sharedContext.delete(deck)
        CoreDataStackManager.sharedInstance().saveContext()
        
        
        self.dismiss(animated: false, completion: nil)

    }
    
    func changeDeckNameHandler(_ newDeckName: String, indexPathOfDeck: IndexPath) {
       
        let deck = decks[(indexPathOfDeck as NSIndexPath).row]
        deck.name = newDeckName
        print(deck.name)
        tableView.reloadRows(at: [indexPathOfDeck], with: .fade)
        CoreDataStackManager.sharedInstance().saveContext()
        self.dismiss(animated: false, completion: nil)
        
        
    }
    


}


extension ViewDecksController : AddDeckViewControllerDelegate {
    func handleAddDeck(_ deckName : String) {
        // First add the things required to update the data source
        let deck = Deck(context: sharedContext, name: deckName, detail: nil)
        decks.append(deck)
        
        // Save it to CoreData
        CoreDataStackManager.sharedInstance().saveContext()
        
        // Reload the tableView
        tableView.reloadData()
        
        // Now dismiss the popup view controller
        self.dismiss(animated: false, completion: nil)
    }
}

extension ViewDecksController : SettingsViewControllerDelegate {
    func changeDeckName(settingsViewController: SettingsViewController) {
        
        let unwrappedIndexPathOfDeck = settingsViewController.indexPathOfDeck
        guard let indexPathOfDeck = unwrappedIndexPathOfDeck else {
            self.dismiss(animated: false, completion: nil)
            return
        }
        let deck = decks[indexPathOfDeck.row]
        deck.name = settingsViewController.deckNameTextField.text!
        print(deck.name)
        tableView.reloadRows(at: [indexPathOfDeck], with: .fade)
        CoreDataStackManager.sharedInstance().saveContext()
        self.dismiss(animated: false, completion: nil)
    }
    func deleteDeck(settingsViewController: SettingsViewController) {
        let unwrappedIndexPathOfDeck = settingsViewController.indexPathOfDeck
        guard let indexPathOfDeck = unwrappedIndexPathOfDeck else {
            self.dismiss(animated: false, completion: nil)
            return
        }
        let deck = decks[indexPathOfDeck.row]
        
        // Update data source and table
        decks.remove(at: indexPathOfDeck.row)
        tableView.deleteRows(at: [indexPathOfDeck], with: .fade)
        removeFromExpandedIndexPaths(indexPathOfDeck)
        
        // Delete flashCard instance by setting it to nil
        deck.flashCards = nil
        sharedContext.delete(deck)
        CoreDataStackManager.sharedInstance().saveContext()
        
        
        self.dismiss(animated: false, completion: nil)

    }
}
