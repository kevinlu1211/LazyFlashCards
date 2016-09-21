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
    case chinese
    case english
}


class AddCardViewController: UIViewController {

    @IBOutlet weak var phraseTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var pronunicationTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var definitionTextField: SkyFloatingLabelTextField!

    @IBOutlet weak var searchButton: RoundView!
    
    @IBOutlet weak var previousButton: RoundView!
    @IBOutlet weak var nextButton: RoundView!
    @IBOutlet weak var addCardButton: RoundView!
    @IBOutlet weak var contentView: UIView!
    var delegate : AddCardViewControllerDelegate?

    
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
    var theme : ThemeStrategy {
        return ThemeFactory.sharedInstance().getTheme()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        currentLanguage = .english
        
        // Disable the previous and next buttons
        setup()
        hideLeftAndRightButtons()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    fileprivate func updateCardLanguageStrategy() {
        print("setting card strategy to \(currentLanguage)")
        cardLanguageStrategy = CardLanguageStrategyFactory.sharedInstance().getStrategy(self.currentLanguage)
    }
    
    func setupTextField(_ textField : SkyFloatingLabelTextField) {
        //        textField.selectedIconColor = theme.getMediumColor()
        textField.selectedLineColor = theme.getMediumColor()
        textField.selectedTitleColor = theme.getMediumColor()
        textField.layer.cornerRadius = theme.getCornerRadiusForButton()
    }
    
    func setupSearchButton() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleSearch))
        searchButton.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func setup() {
        setupSearchButton()
//        setupButton(previousButton)
//        setupButton(nextButton)
//        setupButton(addCardButton)
        setupTextField(phraseTextField)
        setupTextField(pronunicationTextField)
        setupTextField(definitionTextField)
        
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
    
    func handleSearch() {
        searchButton.respondToTap(color: theme.getDarkColor())
        // TODO: Delegate this to the factory methods so that we don't need to have a big switch block
        let phraseText = phraseTextField.text
        if let phrase = phraseText {
            
            // See if transliteration changes the string, as it will change for Chinese but not english
            let mutableString = NSMutableString(string: phrase) as CFMutableString
            CFStringTransform(mutableString, nil, kCFStringTransformToLatin, Bool(0))
            
            // If the mutableString after transliteration is the same as the original string then it must be english
            if(mutableString as String == phrase) {
                currentLanguage = .english
            }
            else {
                currentLanguage = .chinese
            }

        }
        else {
            currentLanguage = .english
        }
        cardLanguageStrategy?.searchPhrase(self)
        
    }
    @IBAction func handleAddCard(_ sender: AnyObject) {
        // First hide the left and right buttons
        hideLeftAndRightButtons()

        // Delegate adding card to DetailDeckViewController
        delegate!.handleAddCard(self, phrase: phraseTextField.text, pronunication: pronunicationTextField.text, definition:  definitionTextField.text)
        
        // Now clear the text fields
        clearTextFields()
     
    }
    @IBAction func handlePreviousResult(_ sender: AnyObject) {
        if (resultIndex > 0) {
            resultIndex -= 1
            cardLanguageStrategy?.updateTextFields(self)

        }
    }
    @IBAction func handleNextResult(_ sender: AnyObject) {
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
        if (previousButton.isHidden == true && nextButton.isHidden == true) {
            return
        }
        else {
            previousButton.isHidden = true
            nextButton.isHidden = true
        }
    }
    
    func showLeftandRightButtons() {
        if(previousButton.isHidden == false && nextButton.isHidden == false) {
            return
        }
        else {
            print("Showing previous and next buttons")
            previousButton.isHidden = false
            nextButton.isHidden = false
        }
  
    }
    
    func buttonsToDisable() {
        print("Current index is \(resultIndex)")
        print("Max index is \(maxIndex)")
        
        if(maxIndex == 0) {
            previousButton.isUserInteractionEnabled = false
            nextButton.isUserInteractionEnabled = false
            return
        }
        if resultIndex <= 0 {
            previousButton.isUserInteractionEnabled = false
            nextButton.isUserInteractionEnabled = true
        }
        else if (resultIndex >= maxIndex) {
            previousButton.isUserInteractionEnabled = true
            nextButton.isUserInteractionEnabled = false
        }
        else {
            previousButton.isUserInteractionEnabled = true
            nextButton.isUserInteractionEnabled = true
        }

    }
    
    
}

extension String {
    func language() -> String? {
        let tagger = NSLinguisticTagger(tagSchemes: [NSLinguisticTagSchemeLanguage], options: 0)
        tagger.string = self
        return tagger.tag(at: 0, scheme: NSLinguisticTagSchemeLanguage, tokenRange: nil, sentenceRange: nil)
    }
}

protocol AddCardViewControllerDelegate : class {
    func handleAddCard(_ addCardViewController: AddCardViewController, phrase : String?, pronunication : String?, definition : String?)
}
