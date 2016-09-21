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
import AEAccordion
import AEXibceptionView
import CoreData

class DetailDeckViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    // MARK: - Properties
    
    // Table View
    fileprivate let cellIdentifier = "CardTableViewCell"
    var tableView: UITableView!
    internal var expandedIndexPaths = [IndexPath]()
    
    // Floating liquid cells
    fileprivate let ADD_CARD_BUTTON_INDEX = 0
    var liquidFloatingCells: [LiquidFloatingCell] = []

    // Core Data
    lazy var sharedContext : NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    var deck : Deck!
    var flashCards : [FlashCard] = []
    var theme : ThemeStrategy {
        return ThemeFactory.sharedInstance().getTheme()
    }
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


}

// MARK: - UITableView methods

extension DetailDeckViewController {
    
    // MARK: - Helpers
    
    func tableViewSetup() {
        tableView = UITableView(frame: view.bounds)
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        self.tableView.separatorStyle = .none
        registerCell()
        tableView.backgroundColor = theme.getDarkColor()
        tableView.reloadData()
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
        return flashCards.count
    }

    @objc(tableView:cellForRowAtIndexPath:) func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Setup cell view
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CardTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        // Setup cell data
        let flashCard = flashCards[(indexPath as NSIndexPath).row]
        cell.headerView.titleLabel.text = flashCard.phrase
        cell.detailView.phraseLabel.text = flashCard.phrase
        cell.detailView.pronunciationLabel.text = flashCard.pronunciation
        cell.detailView.definitionTextView.text = flashCard.definition
        
        
        // Setup cell aesthetics
        cell.setup()
        
        // Setup delegate
        cell.detailView.delegate = self
        
        
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
extension DetailDeckViewController {
    
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
        liquidFloatingCells.append(customCellFactory(ImageName.ADD_CARD_IMAGE_NAME, "Add Card"))
        
        // Setup the frame
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        let navigationBarHeight = self.navigationController!.navigationBar.frame.height
        let buttonHeight = CGFloat(56)
        let floatingFrame = CGRect(x: 0, y: 0 , width: buttonHeight, height: buttonHeight)
        let bottomRightButton = createButton(floatingFrame, .up)
        self.view.addSubview(bottomRightButton)
        bottomRightButton.center = CGPoint(x: self.view.bounds.width - buttonHeight, y: self.view.bounds.height - buttonHeight - statusBarHeight - navigationBarHeight)
        
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
        if index == ADD_CARD_BUTTON_INDEX {
            cardSetupPopup()
        }
        liquidFloatingActionButton.close()
    }
    
    func cardSetupPopup() {
        let cardSetupVC = AddCardViewController(nibName: "AddCardViewController", bundle: nil)
        let popup = PopupDialog(viewController: cardSetupVC, buttonAlignment: .horizontal, transitionStyle: .bounceDown, gestureDismissal: true)
        cardSetupVC.delegate = self
        present(popup, animated: true, completion: nil)
        
    }
    
}

extension DetailDeckViewController : AddCardViewControllerDelegate {
    func handleAddCard(_ addCardViewController : AddCardViewController, phrase: String?, pronunication: String?, definition: String?) {
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

    func handleDeleteAction(_ detailCardView: DetailCardView) {
        print("pressed delete")
        let indexPath = tableView.indexPath(for: detailCardView.getParentTableViewCell())
        if let indexPath = indexPath {
            let flashCard = flashCards[(indexPath as NSIndexPath).row]
            
            // Remove the the flashCard fields from the actors array using the inverse relationship
            flashCard.phrase = nil
            flashCard.pronunciation = nil
            flashCard.definition = nil
            
            // Update the data source
            flashCards.remove(at: (indexPath as NSIndexPath).row)
            removeFromExpandedIndexPaths(indexPath)
            
            // Remove the row from the table
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            
            // Remove the movie from the context
            sharedContext.delete(flashCard)
            CoreDataStackManager.sharedInstance().saveContext()
        }
       
    }
}
