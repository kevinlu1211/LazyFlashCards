//
//  SettingsViewController.swift
//  LazyFlashCards
//
//  Created by Kevin Lu on 11/09/2016.
//  Copyright © 2016 Kevin Lu. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SwiftyButton

class SettingsViewController: UIViewController {

    @IBOutlet weak var deckNameTextField: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var doneButton: SwiftyButton!
    
    @IBOutlet weak var deleteButton: SwiftyButton!
    
    var changeDeckName: ((newDeckName: String, indexPathOfDeck : NSIndexPath) -> ())!
    var deleteDeck : ((indexPathOfDeck : NSIndexPath) -> ())!
    var deck : Deck!
    var indexPathOfDeck : NSIndexPath!
    private var deleteMode = false
    
    var theme : ThemeStrategy {
        return ThemeFactory.sharedInstance().getTheme()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.layer.borderWidth = 2
//        self.view.layer.borderColor = UIColor.blackColor().CGColor
        // Do any additional setup after loading the view.
        setupDoneButtonEnabled()
        setupDeleteButtonEnabled()
        setupTextField()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated. mg
    }
    
    func setupTextField() {
        deckNameTextField.autocorrectionType = .No
        if !deleteMode {
            deckNameTextField.selectedIconColor = theme.getMediumColor()
            deckNameTextField.selectedLineColor = theme.getMediumColor()
            deckNameTextField.selectedTitleColor = theme.getMediumColor()
            deckNameTextField.layer.cornerRadius = theme.getCornerRadiusForButton()
            deckNameTextField.text = deck.name
            deckNameTextField.delegate = self
        }
        else {
            deckNameTextField.selectedIconColor = UIColor.redColor()
            deckNameTextField.selectedLineColor = UIColor.redColor()
            deckNameTextField.selectedTitleColor = UIColor.redColor()
            deckNameTextField.placeholder = "Enter deck name to delete"
            deckNameTextField.titleLabel.text = deck.name
            deckNameTextField.text = ""
        }
    }
    

    func setupDoneButtonEnabled() {
        doneButton.userInteractionEnabled = true
        // Setup button
        doneButton.layer.borderColor = theme.getMediumColor().CGColor
        doneButton.layer.borderWidth = 1
        doneButton.layer.cornerRadius = theme.getCornerRadiusForButton()
        
        // Setup the button when it's not highlighted
        doneButton.buttonColor = UIColor.whiteColor()
        doneButton.setTitleColor(theme.getMediumColor()
, forState: .Normal)
        
    }
    
    
    func setupDeleteButtonEnabled() {
        deleteButton.userInteractionEnabled = true
        // Setup button
        deleteButton.layer.borderColor = UIColor.redColor().CGColor
        deleteButton.layer.borderWidth = 1
        deleteButton.layer.cornerRadius = theme.getCornerRadiusForButton()
        
        // Setup the button when it's not highlighted
        deleteButton.buttonColor = UIColor.whiteColor()
        deleteButton.setTitleColor( UIColor.redColor()
            , forState: .Normal)
    }
    func setupButtonDisabled(swiftyButton : SwiftyButton) {
        
        swiftyButton.userInteractionEnabled = false

        
        // Setup button
        swiftyButton.layer.borderColor = UIColor.grayColor().CGColor
        swiftyButton.layer.borderWidth = 1
        swiftyButton.layer.cornerRadius = theme.getCornerRadiusForButton()
        
        // Setup the button when it's not highlighted
        swiftyButton.buttonColor = UIColor.whiteColor()
        swiftyButton.setTitleColor(UIColor.grayColor(), forState: .Normal)
        

    }


    @IBAction func doneButton(sender: AnyObject) {
    }
    @IBAction func deleteButton(sender: AnyObject) {
        if !deleteMode {
            deleteMode = !deleteMode
            setupTextField()
            setupButtonDisabled(deleteButton)
            setupButtonDisabled(doneButton)
        }
        else {
            deleteDeck(indexPathOfDeck: indexPathOfDeck)
        }
    }
}

extension SettingsViewController : UITextFieldDelegate {
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        print(string)
        let currentText = textField.text! + string
        print(currentText)

        if !deleteMode {
            
        }
        else {
            if(currentText == deck.name) {
                setupDeleteButtonEnabled()
            }
            else {
                setupButtonDisabled(deleteButton)
            }
        }
        return true
    }
}
