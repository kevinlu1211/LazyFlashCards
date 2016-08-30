//
//  CardUpdateStrategyChineseLanguage.swift
//  TiltTheTeacher
//
//  Created by Kevin Lu on 18/06/2016.
//  Copyright © 2016 Kevin Lu. All rights reserved.
//

import Foundation

class CardLanguageStrategyChinese : NSObject, CardLanguageStrategy {
    

    func searchPhrase(addCardViewController : AddCardViewController) -> Void {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            PearsonClient.sharedInstance().retrieveData(addCardViewController.phraseTextField.text!) {
                success, MDBGResults, errorString in
                
                if success {
                    if let results = MDBGResults {
                        addCardViewController.results = results
                        addCardViewController.maxIndex = results.count - 1
                        // Update UI
                        if addCardViewController.maxIndex > -1 {
                            dispatch_async(dispatch_get_main_queue()) {
                                print("There are "  + String(results.count) + "results")
                                for result in results {
                                    let result = result
                                    print(result.headWord)
                                    print(result.pronunciation)
                                    print(result.definition)
                                }
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
                    dispatch_async(dispatch_get_main_queue()) {
                        print(errorString!)
                    }
                }
            }
        }
    }


    internal func updateTextFields(addCardViewController : AddCardViewController) -> Void {
        let currentResult = addCardViewController.results![addCardViewController.resultIndex] as! MDBGData
        addCardViewController.phraseTextField.text = currentResult.headWord
        addCardViewController.pronunicationTextField.text = currentResult.pronunciation
        addCardViewController.definitionTextField.text = currentResult.definition
    }
}