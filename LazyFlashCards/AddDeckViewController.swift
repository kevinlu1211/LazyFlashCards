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
    
    func setupTextField(textField : SkyFloatingLabelTextFieldWithIcon) {
        textField.selectedIconColor = theme.getMediumColor()
        textField.selectedLineColor = theme.getMediumColor()
        textField.selectedTitleColor = theme.getMediumColor()
        textField.layer.cornerRadius = theme.getCornerRadiusForButton()

    }
    
    func setupButton(swiftyButton : SwiftyButton) {
        swiftyButton.buttonColor = theme.getMediumColor()
        swiftyButton.titleLabel?.textColor = theme.getTextColor()
    }
    
    func setup() {
        setupButton(addDeckButton)
        setupTextField(deckNameTextField)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func addDeckButton(sender: AnyObject) {
        // Assuming that there is text
        delegate?.handleAddDeck(deckNameTextField.text!)
        print("Adding deck")
        
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

protocol AddDeckViewControllerDelegate : class {
    func handleAddDeck(deckName : String)
}