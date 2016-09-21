//
//  ColorSchemeFactory.swift
//  LazyFlashCards
//
//  Created by Kevin Lu on 8/09/2016.
//  Copyright © 2016 Kevin Lu. All rights reserved.
//

import Foundation

class ThemeFactory {
    var currentThemeName : ThemeName?
    
    class func sharedInstance() -> ThemeFactory {
        struct Singleton {
            static let sharedInstance = ThemeFactory()
        }
        return Singleton.sharedInstance
    }
    
    func getTheme() -> ThemeStrategy {
        if let themeName = currentThemeName {
            switch themeName {
            case .blue:
                return ThemeStrategyBlue()
            }
        }
        else {
            return ThemeStrategyBlue()
        }
       
    }
    func setTheme(_ themeName : ThemeName) {
        currentThemeName = themeName
    }
    
}
