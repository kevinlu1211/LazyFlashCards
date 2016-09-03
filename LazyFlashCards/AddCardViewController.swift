//
//  AddCardViewController.swift
//  LazyFlashCards
//
//  Created by Kevin Lu on 27/08/2016.
//  Copyright © 2016 Kevin Lu. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SwiftyButton
enum Language {
    case Chinese
    case English
}


class AddCardViewController: UIViewController {

    @IBOutlet weak var phraseTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var pronunicationTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var definitionTextField: SkyFloatingLabelTextField!
    var delegate : AddCardViewControllerDelegate?
    
    @IBOutlet weak var previousButton: SwiftyButton!
    @IBOutlet weak var nextButton: SwiftyButton!
    
    var currentLanguage : Language!  {
        didSet {
            updateCardLanguageStrategy()
        }
    }
    var cardLanguageStrategy : CardLanguageStrategy?

    
    var results : [NSObject]?
    var resultIndex : Int = 0 {
        didSet {
            print("setting result index")
            buttonsToDisable()
        }
    }
    var maxIndex : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentLanguage = .English
        
        // Disable the previous and next buttons

        hideLeftAndRightButtons()

        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func updateCardLanguageStrategy() {
        print("setting card strategy")
        cardLanguageStrategy = CardLanguageStrategyFactory.sharedInstance().getStrategy(self.currentLanguage)
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
        // TODO: Delegate this to the factory methods so that we don't need to have a big switch block
//        showLeftandRightButtons()

        cardLanguageStrategy?.searchPhrase(self)
        
    }
    @IBAction func handleAddCard(sender: AnyObject) {
        // First hide the left and right buttons
        hideLeftAndRightButtons()

        // Delegate adding card to DetailDeckViewController
        delegate!.handleAddCard(self, phrase: phraseTextField.text, pronunication: pronunicationTextField.text, definition:  definitionTextField.text)
        
        // Now clear the text fields
        clearTextFields()
     
    }
    @IBAction func handlePreviousResult(sender: AnyObject) {
        if (resultIndex > 0) {
            resultIndex -= 1
            cardLanguageStrategy?.updateTextFields(self)

        }
    }
    @IBAction func handleNextResult(sender: AnyObject) {
        if (resultIndex < maxIndex) {
            resultIndex += 1
            cardLanguageStrategy?.updateTextFields(self)
        }


    }
    
    func clearTextFields() {
        self.view.fadeOut()
        phraseTextField.text = ""
        pronunicationTextField.text = ""
        definitionTextField.text = ""
        self.view.fadeIn()
    }
    
    func hideLeftAndRightButtons() {
        if (previousButton.hidden == true && nextButton.hidden == true) {
            return
        }
        else {
            previousButton.hidden = true
            nextButton.hidden = true
        }
    }
    
    func showLeftandRightButtons() {
        if(previousButton.hidden == false && nextButton.hidden == false) {
            return
        }
        else {
            print("Showing previous and next buttons")
            previousButton.hidden = false
            nextButton.hidden = false
        }
  
    }
    
    func buttonsToDisable() {
        print("Current index is \(resultIndex)")
        print("Max index is \(maxIndex)")
        
        if(maxIndex == 0) {
            previousButton.enabled = false
            nextButton.enabled = false
            return
        }
        if resultIndex <= 0 {
            previousButton.enabled = false
            nextButton.enabled = true
        }
        else if (resultIndex >= maxIndex) {
            previousButton.enabled = true
            nextButton.enabled = false
        }
        else {
            previousButton.enabled = true
            nextButton.enabled = true
        }

    }
    
    
}

extension String {
    func language() -> String? {
        let tagger = NSLinguisticTagger(tagSchemes: [NSLinguisticTagSchemeLanguage], options: 0)
        tagger.string = self
        return tagger.tagAtIndex(0, scheme: NSLinguisticTagSchemeLanguage, tokenRange: nil, sentenceRange: nil)
    }
}

protocol AddCardViewControllerDelegate : class {
    func handleAddCard(addCardViewController: AddCardViewController, phrase : String?, pronunication : String?, definition : String?)
}