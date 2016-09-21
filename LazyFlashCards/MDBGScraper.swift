//
//  HTMLScraper.swift
//  FlashCards
//
//  Created by Kevin Lu on 4/01/2016.
//  Copyright © 2016 Kevin Lu. All rights reserved.
//

import Foundation

class MDBGScraper {
    
    class func sharedInstance() -> MDBGScraper {
        struct Singleton {
            static var sharedInstance = MDBGScraper()
        }
        return Singleton.sharedInstance
    }

    
    func retrieveData(_ chineseWord : String, completionHandler : (_ success : Bool, _ data : [MDBGData]?, _ errorString : String?) -> Void) {
        let baseURL = "http://chinesedictionary.mobi/?handler=QueryWorddict&mwdqb="
        let query = convertToUTF8Encoding(chineseWord)
        let urlString = baseURL + query
        let url = URL(string: urlString)
        
        var headwordResults = [String]()
        var pronunciationResults = [String]()
        var definitionResults = [String]()
        
        var MDBGResults = [MDBGData]()
        
        let dataObject = try? Data(contentsOf: url!)
        
        if let dataObject = dataObject {
            
            // Scraping definition from source code
            let doc = TFHpple(htmlData: dataObject)
            
            if let chineseArray = doc?.search(withXPathQuery: "//td [@class='chinese']") as? [TFHppleElement] {
                for chinese in chineseArray {
                    let chineseContent = chinese.content
                    let strippedChinese = chineseContent?.replacingOccurrences(of: "\n", with : "")
                    headwordResults.append(strippedChinese!)
                }
            }
            else {
                completionHandler(false, nil, "There was an error in reading the website")
                return
            }
            
            if let pinyinArray = doc?.search(withXPathQuery: "//td[@class='pinyin']") as? [TFHppleElement] {
                for pinyin in pinyinArray {
                    let pinyinContent = pinyin.content
                    let strippedPinyin = pinyinContent?.replacingOccurrences(of: "\n", with: "")
                    pronunciationResults.append(strippedPinyin!)
                    
                }
            }
            else {
                completionHandler(false, nil, "There was an error in reading the website")
                return
            }
            
            if let definitionArray = doc?.search(withXPathQuery: "//td[@class='english']") as? [TFHppleElement] {
                for definition in definitionArray {
                    let definitionContent = definition.content
                    let strippedDefinition = definitionContent?.replacingOccurrences(of: "\n", with: "")
                    definitionResults.append(strippedDefinition!)
                }
            }
            else {
                completionHandler(false, nil, "There was an error in reading the website")
                return
            }
            
        }
        else {
            completionHandler(false, nil, "There was an error in retrieving the webpage")
            return
        }
        
        // Now that we have all the results make them into an array of MDBGData's
        let numberOfResults = headwordResults.count
        if numberOfResults <= 0 {
            completionHandler(false, nil, "No results were found")
        }
        else {
            for index in 0...(numberOfResults - 1) {
                MDBGResults.append(MDBGData(headWord: headwordResults[index], pronunciation: pronunciationResults[index], definition: definitionResults[index]))
            }
        }
         completionHandler(true, MDBGResults, nil)
       
        
    }

    
    func convertToUTF8Encoding(_ chineseWord : String) -> String {
        let utf8EncodingForChineseWord = String(describing: chineseWord.data(using: String.Encoding.utf8)!)
        print(utf8EncodingForChineseWord)
        let strippedString = stripString(utf8EncodingForChineseWord)
        var stringWithPercentages = ""
        var letterIndex = 0
        
        // Add percentage signs
        for char in strippedString.characters {
            if letterIndex == 0 || letterIndex % 2 == 0 {
                stringWithPercentages.append("%" as Character)
            }
            stringWithPercentages.append(char)
            letterIndex += 1
        }
        return stringWithPercentages
    }
    func stripString(_ string: String) -> String {
        var strippedString = string.replacingOccurrences(of: "<", with: "")
        strippedString = strippedString.replacingOccurrences(of: ">", with: "")
        strippedString = strippedString.replacingOccurrences(of: " ", with: "")
        return strippedString
    }
}
