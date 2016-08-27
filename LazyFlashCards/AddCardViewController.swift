//
//  AddCardViewController.swift
//  LazyFlashCards
//
//  Created by Kevin Lu on 27/08/2016.
//  Copyright © 2016 Kevin Lu. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField


class AddCardViewController: UIViewController {

    @IBOutlet weak var phraseTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var pronunicationTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var definitionTextField: SkyFloatingLabelTextField!
    var delegate : AddCardViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

// MARK: - Button Actions
extension AddCardViewController {
    
    @IBAction func handleSearch(sender: AnyObject) {
        // TODO: Delegate this to the factory methods
    }
    @IBAction func handleAddCard(sender: AnyObject) {
        print("delegating add card to delegate")
        delegate!.handleAddCard(self, phrase: phraseTextField.text, pronunication: pronunicationTextField.text, definition:  definitionTextField.text)
     
    }
    func clearTextFields() {
        self.view.fadeOut()
        phraseTextField.text = ""
        pronunicationTextField.text = ""
        definitionTextField.text = ""
        self.view.fadeIn()
    }
    
    
}

protocol AddCardViewControllerDelegate : class {
    func handleAddCard(addCardViewController: AddCardViewController, phrase : String?, pronunication : String?, definition : String?)
}