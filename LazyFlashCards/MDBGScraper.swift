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

    
    func retrieveData(chineseWord : String, completionHandler : (success : Bool, data : [MDBGData]?, errorString : String?) -> Void) {
        let baseURL = "http://chinesedictionary.mobi/?handler=QueryWorddict&mwdqb="
        let query = convertToUTF8Encoding(chineseWord)
        let urlString = baseURL + query
        let url = NSURL(string: urlString)
        
        var headwordResults = [String]()
        var pronunciationResults = [String]()
        var definitionResults = [String]()
        
        var MDBGResults = [MDBGData]()
        
        let dataObject = NSData(contentsOfURL: url!)
        
        if let dataObject = dataObject {
            
            // Scraping definition from source code
            let doc = TFHpple(HTMLData: dataObject)
            
            if let chineseArray = doc.searchWithXPathQuery("//td [@class='chinese']") as? [TFHppleElement] {
                for chinese in chineseArray {
                    let chineseContent = chinese.content
                    let strippedChinese = chineseContent.stringByReplacingOccurrencesOfString("\n", withString : "")
                    headwordResults.append(strippedChinese)
                }
            }
            else {
                completionHandler(success: false, data: nil, errorString: "There was an error in reading the website")
                return
            }
            
            if let pinyinArray = doc.searchWithXPathQuery("//td[@class='pinyin']") as? [TFHppleElement] {
                for pinyin in pinyinArray {
                    let pinyinContent = pinyin.content
                    let strippedPinyin = pinyinContent.stringByReplacingOccurrencesOfString("\n", withString: "")
                    pronunciationResults.append(strippedPinyin)
                    
                }
            }
            else {
                completionHandler(success: false, data: nil, errorString: "There was an error in reading the website")
                return
            }
            
            if let definitionArray = doc.searchWithXPathQuery("//td[@class='english']") as? [TFHppleElement] {
                for definition in definitionArray {
                    let definitionContent = definition.content
                    let strippedDefinition = definitionContent.stringByReplacingOccurrencesOfString("\n", withString: "")
                    definitionResults.append(strippedDefinition)
                }
            }
            else {
                completionHandler(success: false, data: nil, errorString: "There was an error in reading the website")
                return
            }
            
        }
        else {
            completionHandler(success: false, data: nil, errorString: "There was an error in retrieving the webpage")
            return
        }
        
        // Now that we have all the results make them into an array of MDBGData's
        let numberOfResults = headwordResults.count
        if numberOfResults <= 0 {
            completionHandler(success: false, data: nil, errorString: "No results were found")
        }
        else {
            for index in 0...(numberOfResults - 1) {
                MDBGResults.append(MDBGData(headWord: headwordResults[index], pronunciation: pronunciationResults[index], definition: definitionResults[index]))
            }
        }
         completionHandler(success: true, data: MDBGResults, errorString: nil)
       
        
    }

    
    func convertToUTF8Encoding(chineseWord : String) -> String {
        let utf8EncodingForChineseWord = String(chineseWord.dataUsingEncoding(NSUTF8StringEncoding)!)
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
    func stripString(string: String) -> String {
        var strippedString = string.stringByReplacingOccurrencesOfString("<", withString: "")
        strippedString = strippedString.stringByReplacingOccurrencesOfString(">", withString: "")
        strippedString = strippedString.stringByReplacingOccurrencesOfString(" ", withString: "")
        return strippedString
    }
}