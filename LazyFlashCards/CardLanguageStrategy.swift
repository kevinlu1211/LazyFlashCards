//
//  CardLanguageStrategy.swift
//  LazyFlashCards
//
//  Created by Kevin Lu on 4/09/2016.
//  Copyright © 2016 Kevin Lu. All rights reserved.
//

import Foundation

protocol CardLanguageStrategy {
    func searchPhrase(_ addCardViewController : AddCardViewController)
    func updateTextFields(_ addCardViewController : AddCardViewController)
}
