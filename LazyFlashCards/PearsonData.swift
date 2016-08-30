//
//  PearsonDataHelper.swift
//  PearsonAPI
//
//  Created by Kevin Lu on 8/01/2016.
//  Copyright © 2016 Kevin Lu. All rights reserved.
//

import Foundation

class PearsonData : NSObject {
    var headWord : String!
    var pronunciation : String?
    var definition : String!
    init(headWord : String, definition : String) {
        self.headWord = headWord
        self.pronunciation = ""
        self.definition = definition
    }
}
    
    