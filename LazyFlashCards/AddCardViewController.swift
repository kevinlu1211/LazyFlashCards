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
    @IBOutlet weak var searchIcon: UIImageView!
    
    @IBOutlet weak var previousButton: RoundView!
    @IBOutlet weak var previousIcon: UIImageView!
    
    @IBOutlet weak var nextButton: RoundView!
    @IBOutlet weak var nextIcon: UIImageView!
    
    @IBOutlet weak var addCardButton: RoundView!
    @IBOutlet weak var addCardIcon: UIImageView!
    
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
    
    
    func setup() {

        setupSearchButton()

        setupPreviousButton()

        setupNextButton()
        hidePreviousAndNextButtons()
        
        setupAddCardButton()

        setupTextField(phraseTextField)
        print("setting delegate")
        phraseTextField.delegate = self

        setupTextField(pronunicationTextField)
        setupTextField(definitionTextField)

        
        
        
    }
    
    
}

extension AddCardViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentSearchPhrase = textField.text! + string

        if currentSearchPhrase == textField.text! &&
            currentSearchPhrase.characters.count == 1 {
            disableSearchButton()
            disableAddCardButton()
        }
        else {
            enableSearchButton()
            enableAddCardButton()
        }
        return true

    }
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
    
    func handlePreviousResult() {
        previousButton.respondToTap(color: theme.getDarkColor())
        if (resultIndex > 0) {
            resultIndex -= 1
            cardLanguageStrategy?.updateTextFields(self)
            
        }
    }
    func handleNextResult() {
        nextButton.respondToTap(color: theme.getDarkColor())

        if (resultIndex < maxIndex) {
            resultIndex += 1
            cardLanguageStrategy?.updateTextFields(self)
        }
        
        
    }
    
    func handleAddCard() {
        addCardButton.respondToTap(color: theme.getDarkColor())
        
        // First hide the left and right buttons
        hidePreviousAndNextButtons()
        
        // Disable add card and search buttons
        disableAddCardButton()
        disableSearchButton()
        
        // Delegate adding card to DetailDeckViewController
        delegate!.handleAddCard(self, phrase: phraseTextField.text, pronunication: pronunicationTextField.text, definition:  definitionTextField.text)
        
        // Now clear the text fields
        clearTextFields()
        
        
        
    }
    
    
    func clearTextFields() {
        clearTextField(textField: phraseTextField)
        clearTextField(textField: pronunicationTextField)
        clearTextField(textField: definitionTextField)
    }
    
    func clearTextField(textField : SkyFloatingLabelTextField) {
        textField.text = ""
        textField.fadeOut()
        textField.fadeIn()
    }
    
    func hidePreviousAndNextButtons() {
        if (previousButton.alpha == 0 && nextButton.alpha == 0) {
            return
        }
        else {
            previousButton.fadeOut()
            nextButton.fadeOut()
        }
    }
    
    func showPreviousAndNextButtons() {
        print("showPreviousAndNextButtons")
        if(previousButton.alpha == 1 && nextButton.alpha == 1) {
            return
        }
        else {
            print("Showing previous and next buttons")
            previousButton.fadeIn()
            nextButton.fadeIn()
        }
        
    }
    
    func buttonsToDisable() {
        print("Current index is \(resultIndex)")
        print("Max index is \(maxIndex)")
        
        if(maxIndex == 0) {
            disablePreviousButton()
            disableNextButton()
        }
        else {
            if resultIndex <= 0 {
                disablePreviousButton()
                enableNextButton()
            }
            else if (resultIndex >= maxIndex) {
                enablePreviousButton()
                disableNextButton()
                
            }
            else {
                enablePreviousButton()
                enableNextButton()
            }
            
        }
        
    }
    
    
}

extension AddCardViewController {
    func setupSearchButton() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleSearch))
        searchButton.addGestureRecognizer(tapGestureRecognizer)
        disableSearchButton()
    }
    
    func disableSearchButton() {
        searchButton.isUserInteractionEnabled = false
        searchIcon.image = UIImage(named: ImageName.SEARCH_IMAGE_GRAY_NAME)
    }
    
    func enableSearchButton() {
        searchButton.isUserInteractionEnabled = true
        searchIcon.image = UIImage(named : ImageName.SEARCH_IMAGE_DARK_BLUE_NAME)
    }
    
    func setupPreviousButton() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handlePreviousResult))
        previousButton.addGestureRecognizer(tapGestureRecognizer)
        disablePreviousButton()
    }
    
    func disablePreviousButton() {
        previousButton.isUserInteractionEnabled = false
        previousIcon.image = UIImage(named : ImageName.PREVIOUS_IMAGE_GRAY_NAME)
        
    }
    func enablePreviousButton() {
        previousButton.isUserInteractionEnabled = true
        previousIcon.image = UIImage(named: ImageName.PREVIOUS_IMAGE_DARK_BLUE_NAME)
    }
    
    func setupNextButton() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleNextResult))
        nextButton.addGestureRecognizer(tapGestureRecognizer)
        disableNextButton()
    }
    
    func disableNextButton() {
        nextButton.isUserInteractionEnabled = false
        nextIcon.image = UIImage(named :ImageName.NEXT_IMAGE_GRAY_NAME)
    }
    
    func enableNextButton() {
        nextButton.isUserInteractionEnabled = true
        nextIcon.image = UIImage(named : ImageName.NEXT_IMAGE_DARK_BLUE_NAME)
    }
    
    func setupAddCardButton() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleAddCard))
        addCardButton.addGestureRecognizer(tapGestureRecognizer)
        disableAddCardButton()
    }
    
    func disableAddCardButton() {
        addCardButton.isUserInteractionEnabled = false
        addCardIcon.image = UIImage(named : ImageName.ADD_CARD_IMAGE_GRAY_NAME)
        
    }
    
    func enableAddCardButton() {
        addCardButton.isUserInteractionEnabled = true
        addCardIcon.image = UIImage(named : ImageName.ADD_CARD_IMAGE_DARK_BLUE_NAME)
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
