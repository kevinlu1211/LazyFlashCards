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
    func getStrategy(language : Language) -> CardLanguageStrategy {
        switch language {
        case .English:
            return CardLanguageStrategyEnglish()
//        case .Chinese:
//            return CardLanguageStrategyChinese()
        default:
            return CardLanguageStrategyEnglish()
        }
    }
}

protocol CardLanguageStrategy {
//    func previousResult(cardCollectionView : CardCollectionViewCell)
//    func nextResult(cardCollectionView : CardCollectionViewCell)
    func searchPhrase(addCardViewController : AddCardViewController)
    func updateTextFields(addCardViewController : AddCardViewController)
}