//
//  RoundButton.swift
//  LazyFlashCards
//
//  Created by Kevin Lu on 10/09/2016.
//  Copyright © 2016 Kevin Lu. All rights reserved.
//

import UIKit

@IBDesignable public class RoundView: UIView {
    
    @IBInspectable var borderColor: UIColor = UIColor.whiteColor() {
        didSet {
            layer.borderColor = borderColor.CGColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 2.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 0.5 * bounds.size.width
        clipsToBounds = true
    }
    
    func respondToTap() {
        self.backgroundColor = UIColor.whiteColor()
        UIView.animateWithDuration(0.5) {
            self.backgroundColor = UIColor.clearColor() 
        }
    }
}