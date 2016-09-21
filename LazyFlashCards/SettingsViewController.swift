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
    
    // Instead of using delegate pattern
//    var changeDeckName: ((_ newDeckName: String, _ indexPathOfDeck : IndexPath) -> ())!
//    var deleteDeck : ((_ indexPathOfDeck : IndexPath) -> ())!
    var deck : Deck!
    var indexPathOfDeck : IndexPath!
    var delegate : SettingsViewControllerDelegate?
    fileprivate var isDeleting = false
    
    var theme : ThemeStrategy {
        return ThemeFactory.sharedInstance().getTheme()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.layer.borderWidth = 2
//        self.view.layer.borderColor = UIColor.blackColor().CGColor
        // Do any additional setup after loading the view.
        setup()
    }
    func setup() {
        setupDoneButtonEnabled()
        setupDeleteButtonEnabled()
        setupTextField()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated. mg
    }
    
    func setupTextField() {
        deckNameTextField.autocorrectionType = .no
        if !isDeleting {
            deckNameTextField.selectedIconColor = theme.getMediumColor()
            deckNameTextField.selectedLineColor = theme.getMediumColor()
            deckNameTextField.selectedTitleColor = theme.getMediumColor()
            deckNameTextField.layer.cornerRadius = theme.getCornerRadiusForButton()
            deckNameTextField.text = deck.name
            deckNameTextField.delegate = self
        }
        else {
            deckNameTextField.selectedIconColor = UIColor.red
            deckNameTextField.selectedLineColor = UIColor.red
            deckNameTextField.selectedTitleColor = UIColor.red
            deckNameTextField.placeholder = "Enter deck name to delete"
            deckNameTextField.titleLabel.text = deck.name
            deckNameTextField.text = ""
        }
    }
    

    func setupDoneButtonEnabled() {
        doneButton.isUserInteractionEnabled = true
        // Setup button
        doneButton.layer.borderColor = theme.getMediumColor().cgColor
        doneButton.layer.borderWidth = 1
        doneButton.layer.cornerRadius = theme.getCornerRadiusForButton()
        
        // Setup the button when it's not highlighted
        doneButton.buttonColor = UIColor.white
        doneButton.setTitleColor(theme.getMediumColor()
, for: UIControlState())
        
    }
    
    
    func setupDeleteButtonEnabled() {
        deleteButton.isUserInteractionEnabled = true
        // Setup button
        deleteButton.layer.borderColor = UIColor.red.cgColor
        deleteButton.layer.borderWidth = 1
        deleteButton.layer.cornerRadius = theme.getCornerRadiusForButton()
        
        // Setup the button when it's not highlighted
        deleteButton.buttonColor = UIColor.white
        deleteButton.setTitleColor( UIColor.red
            , for: UIControlState())
    }
    
    func setupButtonDisabled(_ swiftyButton : SwiftyButton) {
        
        swiftyButton.isUserInteractionEnabled = false

        
        // Setup button
        swiftyButton.layer.borderColor = UIColor.gray.cgColor
        swiftyButton.layer.borderWidth = 1
        swiftyButton.layer.cornerRadius = theme.getCornerRadiusForButton()
        
        // Setup the button when it's not highlighted
        swiftyButton.buttonColor = UIColor.white
        swiftyButton.setTitleColor(UIColor.gray, for: UIControlState())
        

    }


    @IBAction func doneButton(_ sender: AnyObject) {
        if let delegate = self.delegate {
            delegate.changeDeckName(settingsViewController: self)

        }
//        changeDeckName(newDeckName: deckNameTextField.text!, indexPathOfDeck: indexPathOfDeck)
    }
    @IBAction func deleteButton(_ sender: AnyObject) {
        if !isDeleting {
            isDeleting = !isDeleting
            setupTextField()
            setupButtonDisabled(deleteButton)
            setupButtonDisabled(doneButton)
        }
        else {
            if let delegate = self.delegate {
                delegate.deleteDeck(settingsViewController: self)
            }
//            deleteDeck(indexPathOfDeck: indexPathOfDeck)
        }
    }
}

extension SettingsViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print(string)
        let currentText = textField.text! + string
        print(currentText)

        if !isDeleting {
            
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

protocol SettingsViewControllerDelegate : class  {
    func changeDeckName(settingsViewController : SettingsViewController)
    func deleteDeck(settingsViewController : SettingsViewController)
}
