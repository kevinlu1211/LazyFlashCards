//
//  CardUpdateStrategyChineseLanguage.swift
//  TiltTheTeacher
//
//  Created by Kevin Lu on 18/06/2016.
//  Copyright © 2016 Kevin Lu. All rights reserved.
//

import Foundation

class CardLanguageStrategyChinese : NSObject, CardLanguageStrategy {
    

    func searchPhrase(_ addCardViewController : AddCardViewController) -> Void {
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.high).async {
            print(addCardViewController.phraseTextField.text!)
            MDBGScraper.sharedInstance().retrieveData(addCardViewController.phraseTextField.text!) {
                success, MDBGResults, errorString in
                
                if success {
                    if let results = MDBGResults {
                        addCardViewController.results = results
                        addCardViewController.maxIndex = results.count - 1
                        // Update UI
                        if addCardViewController.maxIndex >= 0 {
                            DispatchQueue.main.async {
                                addCardViewController.showPreviousAndNextButtons()
                                addCardViewController.resultIndex = 0
                                self.updateTextFields(addCardViewController)

                                print("There are "  + String(results.count) + "results")
                                for result in results {
                                    let result = result
                                    print(result.headWord)
                                    print(result.pronunciation)
                                    print(result.definition)
                                }
                                
                                // If there is more than one result then show the previous and next button for the user to be able to switch between the different definitions
                            }
                        }
                    }
                    else {
                        return
                    }
                }
                else {
                    DispatchQueue.main.async {
                        print(errorString!)
                    }
                }
            }
        }
    }


    internal func updateTextFields(_ addCardViewController : AddCardViewController) -> Void {
        let currentResult = addCardViewController.results![addCardViewController.resultIndex] as! MDBGData
        addCardViewController.phraseTextField.text = currentResult.headWord
        addCardViewController.pronunicationTextField.text = currentResult.pronunciation
        addCardViewController.definitionTextField.text = currentResult.definition
    }
}

