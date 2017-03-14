//
//  LazyFlashCardsTests.swift
//  LazyFlashCardsTests
//
//  Created by Kevin Lu on 26/08/2016.
//  Copyright © 2016 Kevin Lu. All rights reserved.
//

import XCTest
@testable import LazyFlashCards

class LazyFlashCardsTests: XCTestCase {
    fileprivate let BASE_URL_FOR_PRONUNCIATION = "https://api.pearson.com/v2/dictionaries/ldoce5/entries?headword="
    fileprivate let BASE_URL_FOR_DEFINITION = "https://api.pearson.com/v2/dictionaries/laad3/entries?headword="
    var query : String!
    let pearsonInstance : PearsonClient = PearsonClient.sharedInstance()
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        query = "hi"

    }
    人
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
//    func testDidSucceed() {
//        var didSucceed = false
//        var pearsonResults : [PearsonData]?
//        pearsonInstance.retrieveDefinition(BASE_URL_FOR_DEFINITION + query, query: query) { success, results, error in
//            if success {
//                didSucceed = true
//                pearsonResults = results!
//            }
//            else {
//                didSucceed = false
//            }
//            
//        }
//        print("The results are: \(pearsonResults)")
//        XCTAssert(didSucceed)
//    }
    
//    func testQueryResultIsNotNull() {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        
//        var pearsonResults = [PearsonData]()
//        pearsonInstance.retrieveDefinition(BASE_URL_FOR_DEFINITION + query, query: query) { success, results, error in
//            if success {
//                pearsonResults = results!
//            }
//            else {
//                XCTAssert(false)
//            }
//            
//        }
//        
//        XCTAssertNotNil(pearsonResults)
//        if (pearsonResults != nil) {
//            let numberOfResults = pearsonResults.count
//            XCTAssert(numberOfResults > 0)
//            print("There are \(numberOfResults) results")
//        }
//
//    }
    
//    func testQueryResultHeadWordIsCorrect() {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        var pearsonResults = [PearsonData]()
//        pearsonInstance.retrieveDefinition(BASE_URL_FOR_DEFINITION + query, query: query) { success, results, error in
//            if success {
//                pearsonResults = results!
//                for result in pearsonResults {
//                    let standardizedHeadword = self.pearsonInstance.standardizeWord(result.headWord)
//                    let standardizedQuery = self.pearsonInstance.standardizeWord(self.query)
//                    print("Result headword is: \(standardizedHeadword)")
//                    print("Query headword is: \(standardizedQuery)")
//                    XCTAssert(standardizedHeadword == standardizedQuery)
//                }
//            }
//            else {
//                XCTAssert(false)
//            }
//            
//        }
//    }
    
}
