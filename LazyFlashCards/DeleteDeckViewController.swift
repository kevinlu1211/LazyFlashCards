//
//  DeleteDeckViewController.swift
//  LazyFlashCards
//
//  Created by Kevin Lu on 5/09/2016.
//  Copyright © 2016 Kevin Lu. All rights reserved.
//

import UIKit

class DeleteDeckViewController: UIViewController {
    var deleteDeck : ((shouldDelete : Bool, indexPathToBeDeleted : NSIndexPath) -> ())?
    var indexPathToBeDeleted : NSIndexPath?
    
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
}
