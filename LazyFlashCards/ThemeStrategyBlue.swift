//
//  ColorSchemeStrategyBlue.swift
//  LazyFlashCards
//
//  Created by Kevin Lu on 8/09/2016.
//  Copyright © 2016 Kevin Lu. All rights reserved.
//

import Foundation
import UIKit

class ThemeStrategyBlue : NSObject, ThemeStrategy {
    private let BACKGROUND_COLOR : UIColor = UIColor(red: 0/255, green: 31/255, blue: 63/255, alpha: 1)
    private let HEADER_COLOR : UIColor = UIColor(red: 8/255, green: 51/255, blue: 88/255, alpha: 1)
    private let DETAIL_COLOR : UIColor = UIColor(red: 13/255, green: 99/255, blue: 165/255, alpha: 1)
    private let CORNER_RADIUS_VIEW : CGFloat = 10.0
    private let CORNER_RADIUS_BUTTON : CGFloat = 5.0
    private let TEXT_COLOR : UIColor = UIColor.whiteColor()
    
    func getBackgroundColor() -> UIColor {
        return BACKGROUND_COLOR
    }
    func getHeaderViewColor() -> UIColor {
        return HEADER_COLOR
    }
    func getDetailViewColor() -> UIColor {
        return DETAIL_COLOR
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
}