//
//  CardUpStrategyEnglishLanguage.swift
//  TiltTheTeacher
//
//  Created by Kevin Lu on 18/06/2016.
//  Copyright © 2016 Kevin Lu. All rights reserved.
//

import Foundation

class CardLanguageStrategyEnglish : NSObject, CardLanguageStrategy {

    
    func searchPhrase(addCardViewController : AddCardViewController) -> Void {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            PearsonClient.sharedInstance().retrieveData(addCardViewController.phraseTextField.text!) {
                success, pearsonResults, errorString in
                
                if success {
                    if let results = pearsonResults {
                        addCardViewController.results = results
                        addCardViewController.maxIndex = results.count - 1
                        // Update UI
                        if addCardViewController.maxIndex >= 0 {
                            dispatch_async(dispatch_get_main_queue()) {
                                addCardViewController.showLeftandRightButtons()
                                addCardViewController.resultIndex = 0
                                self.updateTextFields(addCardViewController)
                                
                                // If there is more than one result then show the previous and next button for the user to be able to switch between the different definitions

                            }
                        }
                    }
                    else {
                        return
                    }
                }
                else {
                    // Show alert view so user knows that there was no result
                    dispatch_async(dispatch_get_main_queue()) {
                        print(errorString!)
                    }
                }
            }
        }
    }
    func updateTextFields(addCardViewController : AddCardViewController) -> Void {
        for result in addCardViewController.results! {
            print(result)
        }
        let currentResult = addCardViewController.results![addCardViewController.resultIndex] as! PearsonData
        addCardViewController.phraseTextField.text = currentResult.headWord
        addCardViewController.pronunicationTextField.text = currentResult.pronunciation
        addCardViewController.definitionTextField.text = currentResult.definition
    }
}