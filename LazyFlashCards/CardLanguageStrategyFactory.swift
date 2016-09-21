//
//  CardUpdateStrategyFactory.swift
//  TiltTheTeacher
//
//  Created by Kevin Lu on 18/06/2016.
//  Copyright © 2016 Kevin Lu. All rights reserved.
//

import Foundation

class CardLanguageStrategyFactory {
    class func sharedInstance() -> CardLanguageStrategyFactory {
        struct Singleton {
            static let sharedInstance = CardLanguageStrategyFactory()
        }
        return Singleton.sharedInstance
    }
    func getStrategy(_ language : Language) -> CardLanguageStrategy {
        switch language {
        case .english:
            print("using english")
            return CardLanguageStrategyEnglish()
        case .chinese:
            print("using chinese")
            return CardLanguageStrategyChinese()
        }
    }
}

