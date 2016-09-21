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
    var deleteDeck : ((_ shouldDelete : Bool, _ indexPathToBeDeleted : IndexPath) -> ())?
    var indexPathToBeDeleted : IndexPath?
    
    @IBOutlet weak var yesButton: SwiftyButton!
    @IBOutlet weak var noButton: SwiftyButton!
    
    var theme : ThemeStrategy {
        return ThemeFactory.sharedInstance().getTheme()
    }

    override func viewDidLoad() {
        setupButton(yesButton)
        setupButton(noButton)
    }
    @IBAction func yesButton(_ sender: AnyObject) {
        if let indexPathToBeDeleted = self.indexPathToBeDeleted {
            deleteDeck!(true, indexPathToBeDeleted)

        }
    }

    @IBAction func noButton(_ sender: AnyObject) {
        if let indexPathToBeDeleted = self.indexPathToBeDeleted {
            deleteDeck!(false, indexPathToBeDeleted)
            
        }
    }
    
    func setupButton(_ swiftyButton : SwiftyButton) {
        swiftyButton.buttonColor = theme.getMediumColor()
        swiftyButton.titleLabel?.textColor = theme.getTextColor()
    }

}
