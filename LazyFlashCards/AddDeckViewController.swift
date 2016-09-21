//
//  AddDeckViewController.swift
//  
//
//  Created by Kevin Lu on 21/08/2016.
//
//

import UIKit
import SkyFloatingLabelTextField
import SwiftyButton

class AddDeckViewController: UIViewController {
    
    @IBOutlet weak var deckNameTextField: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var addDeckButton: SwiftyButton!
    
    var delegate : AddDeckViewControllerDelegate?

    var theme : ThemeStrategy {
        return ThemeFactory.sharedInstance().getTheme()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                // Do any additional setup after loading the view.
        setup()
        
    }
    
    func setupTextField(_ textField : SkyFloatingLabelTextFieldWithIcon) {
        textField.delegate = self
        textField.selectedIconColor = theme.getMediumColor()
        textField.selectedLineColor = theme.getMediumColor()
        textField.selectedTitleColor = theme.getMediumColor()
        textField.layer.cornerRadius = theme.getCornerRadiusForButton()

    }
    
    func setupButton(_ swiftyButton : SwiftyButton) {
        //
        swiftyButton.isEnabled = true

        // Setup button
        swiftyButton.layer.borderColor = theme.getMediumColor().cgColor
        swiftyButton.layer.borderWidth = 1
        swiftyButton.layer.cornerRadius = theme.getCornerRadiusForButton()
        
        // Setup the button when it's not highlighted
        swiftyButton.buttonColor = UIColor.white
        swiftyButton.shadowColor = UIColor.white
        swiftyButton.setTitleColor(theme.getMediumColor(), for: UIControlState())
        
        swiftyButton.disabledButtonColor = UIColor.white
        swiftyButton.disabledShadowColor = UIColor.white
    }
    
    func disableButton(_ swiftyButton : SwiftyButton) {
        
        swiftyButton.isEnabled = false
        
        
        // Setup button
        swiftyButton.layer.borderColor = UIColor.gray.cgColor
        swiftyButton.layer.borderWidth = 1
        swiftyButton.layer.cornerRadius = theme.getCornerRadiusForButton()
        
        // Setup the button when it's not highlighted
        swiftyButton.disabledButtonColor = UIColor.white
        swiftyButton.disabledShadowColor = UIColor.white
        swiftyButton.setTitleColor(UIColor.gray, for: UIControlState())
        
        
    }
    
    func setup() {
        disableButton(addDeckButton)
        setupTextField(deckNameTextField)
    }


    @IBAction func addDeckButton(_ sender: AnyObject) {
        delegate?.handleAddDeck(deckNameTextField.text!)
        
    }


}

extension AddDeckViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentDeckName = textField.text! + string
        if currentDeckName != "" {
            setupButton(addDeckButton)
        }
        else {
            disableButton(addDeckButton)
        }
        return true
    }
}

protocol AddDeckViewControllerDelegate : class {
    func handleAddDeck(_ deckName : String)
}
