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

class ViewDecksController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    
    private let cellIdentifier = "CustomTableViewCell"
    private var days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    private let ADD_DECK_BUTTON_INDEX = 0
    var liquidFloatingCells: [LiquidFloatingCell] = []
    var hidingNavBarManager: HidingNavigationBarManager?
    var tableView: UITableView!

    
    /// Array of `NSIndexPath` objects for all of the expanded cells.
    internal var expandedIndexPaths = [NSIndexPath]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSBundle.mainBundle().infoDictionary!["CFBundleName"] as? String

        tableView = UITableView(frame: view.bounds)
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        
        hidingNavBarManager = HidingNavigationBarManager(viewController: self, scrollView: tableView)
        
        tableViewSetup()
        expandFirstCell()
        liquidButtonSetup()
        
        if let navController = navigationController {
            styleNavigationController(navController)
        }
//        hidingNavBarManager?.delegate = self


    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        hidingNavBarManager?.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        hidingNavBarManager?.viewDidLayoutSubviews()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        hidingNavBarManager?.viewWillDisappear(animated)
    }
    
    func styleNavigationController(navigationController: UINavigationController){
        navigationController.navigationBar.translucent = true
        navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController.navigationBar.tintColor = UIColor.whiteColor()
        navigationController.navigationBar.barTintColor = UIColor(red: 41/255, green: 141/255, blue: 250/255, alpha: 1)
    }

}

// MARK: - UITableView methods

extension ViewDecksController {
    // MARK: - Helpers
    
    func tableViewSetup() {
        self.tableView.separatorStyle = .None
        registerCell()
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
        return days.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! CustomTableViewCell
        //        cell.contentView.hidden = true
        cell.detailView.delegate = self
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return expandedIndexPaths.contains(indexPath) ? 200.0 : 50.0
    }
    
    func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool {
        hidingNavBarManager?.shouldScrollToTop()
        return true
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
extension ViewDecksController : DetailViewProtocol {
    func handleButton(detailView: DetailView) {
//        let detailTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("DetailTableViewController") as! DetailTableViewController
//        let indexPath = tableView.indexPathForCell(detailView.getParentTableViewCell())
//        if let indexPath = indexPath {
//            detailTableViewController.day = days[indexPath.row]
//        }
//        self.navigationController!.pushViewController(detailTableViewController, animated: true)

        print("handled the button woohoo")
    }
}

extension ViewDecksController : AddDeckViewControllerDelegate {
    func handleAddDeck(deckName : String) {
        // First add the things required to update the data source
        days.append(deckName)
        print(days)
        tableView.reloadData()
        
        // Now dismiss the popup view controller
        self.dismissViewControllerAnimated(false, completion: nil)
    }
}
