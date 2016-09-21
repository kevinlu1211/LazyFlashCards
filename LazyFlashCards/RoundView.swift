//
//  RoundButton.swift
//  LazyFlashCards
//
//  Created by Kevin Lu on 10/09/2016.
//  Copyright © 2016 Kevin Lu. All rights reserved.
//

import UIKit

@IBDesignable
open class RoundView: UIView {
    override open var isUserInteractionEnabled: Bool {
        didSet {
            if isUserInteractionEnabled == false {
                borderColor = UIColor.gray
            }
        }
    }
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 2.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 0.5 * bounds.size.width
        clipsToBounds = true
    }

    
    func respondToTap(color : UIColor = UIColor.white) {
        let originalColor = self.backgroundColor
        self.backgroundColor = color
        UIView.animate(withDuration: 0.5, animations: {
            self.backgroundColor = originalColor
        }) 
    }
    
    
}
