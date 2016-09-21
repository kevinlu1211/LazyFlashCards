//
//  ColorSchemeStrategyBlue.swift
//  LazyFlashCards
//
//  Created by Kevin Lu on 8/09/2016.
//  Copyright © 2016 Kevin Lu. All rights reserved.
//

import Foundation
import UIKit
import ChameleonFramework



class ThemeStrategyBlue : NSObject, ThemeStrategy {
    fileprivate let DARK_COLOR : UIColor = UIColor(red: 0/255, green: 31/255, blue: 63/255, alpha: 1)
    fileprivate let MEDIUM_COLOR : UIColor = UIColor(red: 8/255, green: 51/255, blue: 88/255, alpha: 1)
    fileprivate let LIGHT_COLOR : UIColor = UIColor.flatSkyBlue()
    fileprivate let CONTRAST_COLOR : UIColor = UIColor.flatYellow()
    fileprivate let CORNER_RADIUS_VIEW : CGFloat = 10.0
    fileprivate let CORNER_RADIUS_BUTTON : CGFloat = 5.0
    fileprivate let TEXT_COLOR : UIColor = UIColor.white
    fileprivate let CARD_COLOR : UIColor = UIColor.flatYellow()
    
    
    func getDarkColor() -> UIColor {
        return DARK_COLOR
    }
    func getMediumColor() -> UIColor {
        return MEDIUM_COLOR
    }
    func getLightColor() -> UIColor {
        return LIGHT_COLOR
    }
    func getContrastColor() -> UIColor {
        return CONTRAST_COLOR
    }
    func getCornerRadiusForView() -> CGFloat {
        return CORNER_RADIUS_VIEW
    }
    func getCornerRadiusForButton() -> CGFloat {
        return CORNER_RADIUS_BUTTON
    }
    func getTextColor() -> UIColor {
        return TEXT_COLOR
    }
    func getCardColor() -> UIColor {
        return CARD_COLOR
    }
}
