//
//  AddDeckViewController.swift
//  
//
//  Created by Kevin Lu on 21/08/2016.
//
//

import UIKit
import SkyFloatingLabelTextField

class AddDeckViewController: UIViewController {
    
    @IBOutlet weak var deckNameTextField: SkyFloatingLabelTextFieldWithIcon!
    var delegate : AddDeckViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("AddDeckViewController is loaded")
        print(self.view.frame)
        // Do any additional setup after loading the view.
        deckNameTextField.iconText = "\u{f072}"
        
        
        
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