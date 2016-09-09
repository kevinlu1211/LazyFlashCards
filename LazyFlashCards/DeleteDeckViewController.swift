//
//  DeleteDeckViewController.swift
//  LazyFlashCards
//
//  Created by Kevin Lu on 5/09/2016.
//  Copyright © 2016 Kevin Lu. All rights reserved.
//

import UIKit
import SwiftyButton

class DeleteDeckViewController: UIViewController {
    var deleteDeck : ((shouldDelete : Bool, indexPathToBeDeleted : NSIndexPath) -> ())?
    var indexPathToBeDeleted : NSIndexPath?
    
    @IBOutlet weak var yesButton: SwiftyButton!
    @IBOutlet weak var noButton: SwiftyButton!
    
    var theme : ThemeStrategy {
        return ThemeFactory.sharedInstance().getTheme()
    }

    override func viewDidLoad() {
        setupButton(yesButton)
        setupButton(noButton)
    }
    @IBAction func yesButton(sender: AnyObject) {
        if let indexPathToBeDeleted = self.indexPathToBeDeleted {
            deleteDeck!(shouldDelete: true, indexPathToBeDeleted: indexPathToBeDeleted)

        }
    }

    @IBAction func noButton(sender: AnyObject) {
        if let indexPathToBeDeleted = self.indexPathToBeDeleted {
            deleteDeck!(shouldDelete: false, indexPathToBeDeleted: indexPathToBeDeleted)
            
        }
    }
    
    func setupButton(swiftyButton : SwiftyButton) {
        swiftyButton.buttonColor = theme.getMediumColor()
        swiftyButton.titleLabel?.textColor = theme.getTextColor()
    }

}
