//
//  UIColorEx.swift
//  LiquidLoading
//
//  Created by Takuma Yoshida on 2015/08/21.
//  Copyright (c) 2015年 yoavlt. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    var redCGFloat: CGFloat {
        get {
            let components = self.cgColor.components
            return components![0]
        }
    }
    
    var greenCGFloat: CGFloat {
        get {
            let components = self.cgColor.components
            return components![1]
        }
    }
    
    var blueCGFloat: CGFloat {
        get {
            let components = self.cgColor.components
            return components![2]
        }
    }
    
    var alphaCGFloat: CGFloat {
        get {
            return self.cgColor.alpha
        }
    }

    func alpha(_ alpha: CGFloat) -> UIColor {
        return UIColor(red: self.redCGFloat, green: self.greenCGFloat, blue: self.blueCGFloat, alpha: alphaCGFloat)
    }
    
    func white(_ scale: CGFloat) -> UIColor {
        return UIColor(
            red: self.redCGFloat + (1.0 - self.redCGFloat) * scale,
            green: self.greenCGFloat + (1.0 - self.greenCGFloat) * scale,
            blue: self.blueCGFloat + (1.0 - self.blueCGFloat) * scale,
            alpha: 1.0
        )
    }
}
