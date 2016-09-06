//
//  DetailDeckViewController.swift
//  LazyFlashCards
//
//  Created by Kevin Lu on 27/08/2016.
//  Copyright © 2016 Kevin Lu. All rights reserved.
//

import UIKit
import LiquidFloatingActionButton
import PopupDialog
import HidingNavigationBar
import AEAccordion
import AEXibceptionView
import CoreData

class DetailDeckViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    // MARK: - Properties
    
    // Table View
    private let cellIdentifier = "CardTableViewCell"
    var tableView: UITableView!
    internal var expandedIndexPaths = [NSIndexPath]()
    
    // Floating liquid cells
    private let ADD_CARD_BUTTON_INDEX = 0
    var liquidFloatingCells: [LiquidFloatingCell] = []

    // Core Data
    lazy var sharedContext : NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    var deck : Deck!
    var flashCards : [FlashCard] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSetup()
        setupDeck()
        
        
        liquidButtonSetup()

        // Do any additional setup after loading the view.
    }

    
    func setupDeck() {
        deck.createFlashCards()
        if let useableFlashCards = deck.useableFlashCards {
            flashCards = useableFlashCards
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - UITableView methods

extension DetailDeckViewController {
    
    // MARK: - Helpers
    
    func tableViewSetup() {
        tableView = UITableView(frame: view.bounds)
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        self.tableView.separatorStyle = .None
        registerCell()
        tableView.reloadData()
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
        return flashCards.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Setup cell view
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! CardTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        // Setup cell data
        let flashCard = flashCards[indexPath.row]
        cell.headerView.titleLabel.text = flashCard.phrase
        cell.detailView.phraseLabel.text = flashCard.phrase
        cell.detailView.pronunciationLabel.text = flashCard.pronunciation
        cell.detailView.definitionTextView.text = flashCard.definition
        cell.detailView.definitionTextView.userInteractionEnabled = false
        // Setup delegate
        cell.detailView.delegate = self
        
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
extension DetailDeckViewController {
    
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

extension DetailDeckViewController : LiquidFloatingActionButtonDataSource, LiquidFloatingActionButtonDelegate{
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
        liquidFloatingCells.append(customCellFactory("ic_brush", "Add Card"))
        
        // Setup the frame
        
        //        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        //        let navigationBarHeight = self.navigationController!.navigationBar.frame.height
        let buttonHeight = CGFloat(56)
        let floatingFrame = CGRect(x: 0, y: 0 , width: buttonHeight, height: buttonHeight)
        let bottomRightButton = createButton(floatingFrame, .Up)
        self.view.addSubview(bottomRightButton)
        //        bottomRightButton.center = CGPointMake(self.view.bounds.width - 56 - 16, self.view.bounds.height - 56 - 16 - statusBarHeight - navigationBarHeight)
        bottomRightButton.center = CGPointMake(self.view.bounds.width - buttonHeight, self.view.bounds.height - buttonHeight)
        
    }
    
    func numberOfCells(liquidFloatingActionButton: LiquidFloatingActionButton) -> Int {
        return liquidFloatingCells.count
    }
    
    func cellForIndex(index: Int) -> LiquidFloatingCell {
        return liquidFloatingCells[index]
    }
    
    func liquidFloatingActionButton(liquidFloatingActionButton: LiquidFloatingActionButton, didSelectItemAtIndex index: Int) {
        print("did Tapped! \(index)")
        if index == ADD_CARD_BUTTON_INDEX {
            cardSetupPopup()
        }
        liquidFloatingActionButton.close()
    }
    
    func cardSetupPopup() {
        let cardSetupVC = AddCardViewController(nibName: "AddCardViewController", bundle: nil)
        let popup = PopupDialog(viewController: cardSetupVC, transitionStyle: .BounceDown, buttonAlignment: .Horizontal, gestureDismissal: true)
        cardSetupVC.delegate = self
        presentViewController(popup, animated: true, completion: nil)
        
    }
    
}

extension DetailDeckViewController : AddCardViewControllerDelegate {
    func handleAddCard(addCardViewController : AddCardViewController, phrase: String?, pronunication: String?, definition: String?) {
        print("creating new card")
        // Create the new flashCard
        let flashCard = FlashCard(context: sharedContext, phrase: phrase!, pronunciation: pronunication!, definition: definition!)
        
        print("saving new card")
        // Save make the association for flashCards and deck and then flashCard into CoreData
        flashCard.deck = self.deck
        CoreDataStackManager.sharedInstance().saveContext()
        
        print("reloading data")
        // Now update the data source and reload the tableView
        flashCards.append(flashCard)
        tableView.reloadData()
        
    }
}

extension DetailDeckViewController : DetailCardViewDelegate {
    func handleEditAction(detailCardView: DetailCardView) {
        print("pressed edit")
    }
    func handleDeleteAction(detailCardView: DetailCardView) {
        print("pressed delete")
        let indexPath = tableView.indexPathForCell(detailCardView.getParentTableViewCell())
        if let indexPath = indexPath {
            let flashCard = flashCards[indexPath.row]
            
            // Remove the the flashCard fields from the actors array using the inverse relationship
            flashCard.phrase = nil
            flashCard.pronunciation = nil
            flashCard.definition = nil
            
            // Update the data source
            flashCards.removeAtIndex(indexPath.row)
            removeFromExpandedIndexPaths(indexPath)
            
            // Remove the row from the table
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            
            // Remove the movie from the context
            sharedContext.deleteObject(flashCard)
            CoreDataStackManager.sharedInstance().saveContext()
        }
       
    }
}
