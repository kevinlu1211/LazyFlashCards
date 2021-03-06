//
//  CardUpStrategyEnglishLanguage.swift
//  TiltTheTeacher
//
//  Created by Kevin Lu on 18/06/2016.
//  Copyright © 2016 Kevin Lu. All rights reserved.
//

import Foundation

class CardLanguageStrategyEnglish : NSObject, CardLanguageStrategy {

    
    func searchPhrase(_ addCardViewController : AddCardViewController) -> Void {
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.high).async {
            PearsonClient.sharedInstance().retrieveData(addCardViewController.phraseTextField.text!) {
                success, pearsonResults, errorString in
                
                if success {
                    if let results = pearsonResults {
                        addCardViewController.results = results
                        addCardViewController.maxIndex = results.count - 1
                        print(" addCardViewController.maxIndex = \(addCardViewController.maxIndex)")
                        // Update UI
                        if addCardViewController.maxIndex >= 1 {
                            DispatchQueue.main.async {
                                addCardViewController.showPreviousAndNextButtons()
                                addCardViewController.resultIndex = 0
                                self.updateTextFields(addCardViewController)
                                
                                // If there is more than one result then show the previous and next button for the user to be able to switch between the different definitions

                            }
                        }
                        else if addCardViewController.maxIndex == 0 {
                            DispatchQueue.main.async {
                                addCardViewController.resultIndex = 0
                                self.updateTextFields(addCardViewController)

                            }
                        }
                    }
                    else {
                        return
                    }
                }
                else {
                    // Show alert view so user knows that there was no result
                    DispatchQueue.main.async {
                        print("There was no result")
                        print(errorString!)
                    }
                }
            }
        }
    }
    func updateTextFields(_ addCardViewController : AddCardViewController) -> Void {

        let currentResult = addCardViewController.results![addCardViewController.resultIndex] as! PearsonData
        addCardViewController.phraseTextField.text = currentResult.headWord
        addCardViewController.pronunicationTextField.text = currentResult.pronunciation
        addCardViewController.definitionTextField.text = currentResult.definition
    }
}

