//
//  MDBGData.swift
//  FlashCards
//
//  Created by Kevin Lu on 8/01/2016.
//  Copyright © 2016 Kevin Lu. All rights reserved.
//

import Foundation

class MDBGData: NSObject {
    var headWord : String!
    var pronunciation : String?
    var definition : String?
    init(headWord : String, pronunciation : String, definition : String) {
        self.headWord = headWord
        self.pronunciation = pronunciation
        self.definition = definition
    }
}