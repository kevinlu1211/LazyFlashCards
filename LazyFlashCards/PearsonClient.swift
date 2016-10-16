//
//  PearsonAPI.swift
//  PearsonAPI
//
//  Created by Kevin Lu on 8/01/2016.
//  Copyright © 2016 Kevin Lu. All rights reserved.
//

import Foundation

class PearsonClient {
    fileprivate let BASE_URL_FOR_PRONUNCIATION = "https://api.pearson.com/v2/dictionaries/ldoce5/entries?headword="
    fileprivate let BASE_URL_FOR_DEFINITION = "https://api.pearson.com/v2/dictionaries/laad3/entries?headword="
    class func sharedInstance() -> PearsonClient {
        struct Singleton {
            static var sharedInstance = PearsonClient()
        }
        return Singleton.sharedInstance
    }
    
    func retrieveData(_ englishWord : String, completionHandler : @escaping (_ success: Bool, _ data : [PearsonData]?, _ errorString : String?) -> Void) {

        let query = createQuery(englishWord)
        let urlStringForPronunciation = BASE_URL_FOR_PRONUNCIATION + query
        let urlStringForDefinition = BASE_URL_FOR_DEFINITION + query
        var pronunciation = ""
        var pearsonResults = [PearsonData]()
        
        // First get the definition
        retrieveDefinition(urlStringForDefinition, query: query) { success, result, error in
            if success {
                pearsonResults = result!
                
                print("-----Finishing getting results for definition-----")
                for result in pearsonResults {
                    print("Result for headword: \(result.headWord)")
                    print("Result for definition: \(result.definition)")
                }
                
                // Now get the pronunciation
                self.retrievePronuciation(urlStringForPronunciation, query: query) { success, result, error in
                    
                    // If there is no error then update the pronunciation in the PearsonResults
                    if success {
                        pronunciation = result!
                        for result in pearsonResults {
                            result.pronunciation = pronunciation
                        }
                        print("-----Finishing getting results for pronunciation-----")

                        for result in pearsonResults {
                            print("Result for headword: \(result.headWord)")
                            print("Result for definition: \(result.definition)")
                            print("Result for pronunciation: \(result.pronunciation)")
                        }
                        completionHandler(true, pearsonResults, nil)
                    }
                    else {
                        completionHandler(false, pearsonResults, error)
                    }
                }
            }
            else {
                completionHandler(false, nil, error)
            }
            
        }
    }
    
    
    func retrieveDefinition(_ urlString : String!, query : String!, completionHandler : @escaping (_ success: Bool, _ definitions : [PearsonData]?, _ errorString : String?) -> Void) {
        var request : NSMutableURLRequest
        let url = URL(string: urlString)
        
        // Check if the url is valid!
        if let url = url {
            request = NSMutableURLRequest(url: url)
        }
        else {
            completionHandler(false, nil, "There was an error in the request for data, check internet connection and language settings")
            return
        }
        
        let session = URLSession.shared
        var pearsonResults = [PearsonData]()
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            if error != nil {
                completionHandler(false, nil, "There was a networking error")
                return
            }
            if data == nil {
                completionHandler(false, nil, "There was an error in the request for data")
                return
            }
            
            let parsedResult : AnyObject?
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as AnyObject?
            } catch {
                completionHandler(false, nil, "There was an error in the conversion for data")
                return
            }
            
            // Now parse the results
            let numberOfResults = parsedResult!["count"] as! Int
            print("There are: " + String(numberOfResults) + "result(s) in the pronunciation data")
            
            if numberOfResults == 0 {
                completionHandler(false, nil, "No results were found")
                return
            }
            
            var errorString = ""
            for index in 0...(numberOfResults - 1) {
                let results = parsedResult!["results"]! as! [[String : AnyObject]]
                let result = results[index]
//                print("In Definition")
//                print(result)
                // First check if we can find the headword
                if result["headword"] === nil {
                    continue
                }
    
                
                let headWord = result["headword"] as! String!
                
                // Create the comparison terms as the Pearson's dictionary API will return similar words to the user input
                let comparisonHeadWord = self.standardizeWord(headWord)
                let comparisonQuery = self.standardizeWord(query)
                
                if comparisonHeadWord == comparisonQuery {
                    
                    let unwrappedSenses = result["senses"] as? [AnyObject]
                    guard let senses = unwrappedSenses else {
                        errorString = "No results for senses were found"
                        continue
                    }
                    
                    let unwrappedSense = senses[0] as? [String : AnyObject]
                    guard let sense = unwrappedSense else {
                        errorString = "No results for a sense was found"
                        continue
                    }
                    
                    
                    if let definition = sense["definition"] as? String {
                        let userHeadWord = self.recreateUserInput(query)
                        let pearsonData = PearsonData(headWord: userHeadWord, definition: definition)
                        pearsonResults.append(pearsonData)
                    }
                    else {
                        let unwrappedSubsenses = sense["subsenses"] as? [AnyObject]
                        guard let subsense = unwrappedSubsenses else {
                            errorString = "No results for subsenses were found"
                            continue
                        }
                        
                        let definition = subsense[0]["definition"] as! String
                        let userHeadWord = self.recreateUserInput(query)
                        let pearsonData = PearsonData(headWord: userHeadWord, definition: definition)
                        pearsonResults.append(pearsonData)
                    }
                }
            }
            if pearsonResults.count == 0 {
                completionHandler(false, nil, "No results were found")
            }
            else {
                completionHandler(true, pearsonResults, nil)
                
            }
        })
        task.resume()
    }
    
    func retrievePronuciation(_ urlString : String!, query: String!, completionHandler : @escaping (_ success: Bool, _ pronunciation : String?, _ errorString : String?) -> Void) {
        
        var request : NSMutableURLRequest?
        let url = URL(string: urlString)
        
        if let url = url {
            request = NSMutableURLRequest(url: url)
        }
        else {
            completionHandler(false, nil, "There was an error in the request for data, check internet connection and language settings")
            return
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request! as URLRequest, completionHandler: { data, response, error in
            if error != nil {
                completionHandler(false, nil, "There was a networking error")
                return
            }
            if data == nil {
                completionHandler(false, nil, "There was an error in the request for data")
                return
            }
            
            let parsedResult : AnyObject?
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as AnyObject
            } catch {
                completionHandler(false, nil, "There was an error in the conversion for data")
                return
            }
            
            let numberOfResults = parsedResult!["count"] as! Int
            
            if numberOfResults == 0 {
                completionHandler(false, nil, "No results were found")
                return
            }
            
//            print("In pronunciation")
//            
//            for index in 0...(numberOfResults - 1) {
//                let results = parsedResult!["results"]! as! [[String : AnyObject]]
//                let result = results[index]
//                let headword = result["headword"] as! String!
//                if (headword == "human") {
//                    print(result)
//                }
//            }
            
            // Iterate through our results and see if we can find the phonetic characters associated with our headword

            var errorString = ""
            for index in 0...(numberOfResults - 1) {
                let results = parsedResult!["results"]! as! [[String : AnyObject]]
                let result = results[index]
                // First check if we can find the headword
                if result["headword"] === nil {
                    continue
                }
                else {
                    let headWord = result["headword"] as! String!
                    
                    // Create the comparison terms
                    let comparisonHeadWord = self.standardizeWord(headWord)
                    let comparisonQuery = self.standardizeWord(query)
                    
                    // If we can find it check if the headword is the same as the query
                    if comparisonHeadWord == comparisonQuery {
                        

                        let unwrappedPronunciations = result["pronunciations"] as? [AnyObject]
                        guard let pronunciations = unwrappedPronunciations else {
                            errorString = "No results for pronunciations were found"
                            continue
                        }
                        
                        let unwrappedPronunciation = pronunciations[0] as? [String : AnyObject]
                        guard let pronunciation = unwrappedPronunciation else {
                            errorString = "No result for pronunciation was found"
                            continue
                        }
                        
                        let unwrappedIPA = pronunciation["ipa"] as? String
                        guard let ipa = unwrappedIPA else {
                            errorString = "No results for phonetic text was found"
                            continue
                        }
                        
                        // everything is found so we can return the pronunciation
                        completionHandler(true, ipa, nil)
                        print("Found phonetic text: \(ipa)")
                        return
                    }
                }
            }
            completionHandler(false, nil, errorString)
        }) 
        task.resume()
    }

    
    func standardizeWord(_ string : String!) -> String {
        var standardizedString = string.replacingOccurrences(of: " ", with: "")
        standardizedString = standardizedString.replacingOccurrences(of: "+", with: "")
        return standardizedString.lowercased()
    }
    
    func createQuery(_ string : String!) -> String {
        let query = string.replacingOccurrences(of: " ", with: "+")
        return query
    }
    
    // The inverse of createQuery for output on UI
    func recreateUserInput(_ string : String!) -> String {
        let userInput = string.replacingOccurrences(of: "+", with: " ")
        return userInput
    }
}
