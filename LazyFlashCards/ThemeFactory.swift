//
//  ColorSchemeFactory.swift
//  LazyFlashCards
//
//  Created by Kevin Lu on 8/09/2016.
//  Copyright © 2016 Kevin Lu. All rights reserved.
//

import Foundation

class ThemeFactory {
    class func sharedInstance() -> ThemeFactory {
        struct Singleton {
            static let sharedInstance = ThemeFactory()
        }
        return Singleton.sharedInstance
    }
    
    func getStrategy(themeName : ThemeName) -> ThemeStrategy {
        switch themeName {
        case .Blue:
            return ThemeStrategyBlue()
        }
        
    }
}