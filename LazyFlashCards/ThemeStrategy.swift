//
//  ColorScheme.swift
//  LazyFlashCards
//
//  Created by Kevin Lu on 8/09/2016.
//  Copyright © 2016 Kevin Lu. All rights reserved.
//

import Foundation
import UIKit

protocol ThemeStrategy {
    func getBackgroundColor() -> UIColor
    func getHeaderViewColor() -> UIColor
    func getDetailViewColor() -> UIColor
    func getCornerRadiusForView() -> CGFloat
    func getCornerRadiusForButton() -> CGFloat
    func getTextColor() -> UIColor
}