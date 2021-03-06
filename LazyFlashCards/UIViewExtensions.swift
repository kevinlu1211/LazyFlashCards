 //
//  UIViewExtensions.swift
//  FlashCards
//
//  Created by Kevin Lu on 3/01/2016.
//  Copyright © 2016 Kevin Lu. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func fadeIn(_ duration : TimeInterval = 1.0, delay : TimeInterval = 0.0, alpha : CGFloat = 1.0, completion: ((Bool) -> Void)? = {(finished: Bool) -> Void in }) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {self.alpha = alpha}, completion: completion)
    }
    
    func fadeOut(_ duration : TimeInterval = 1.0, delay : TimeInterval = 0.0, alpha : CGFloat = 0.0, completion: ((Bool) -> Void)? = {(finished: Bool) -> Void in }) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseOut, animations: {self.alpha = alpha}, completion: completion)
    }
    func blurView(duration : TimeInterval = 1.0, alpha : CGFloat = 1.0, style: UIBlurEffectStyle) {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = alpha
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
        
    }
    func removeEffects() {
        for subview in self.subviews {
            if (subview is UIVisualEffectView) {
                subview.removeFromSuperview()
            }
        }
    }
    func addBackground(_ backgroundImageName : String!) {
        // screen width and height:
        let width = self.bounds.size.width
        let height = self.bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        imageViewBackground.image = UIImage(named: backgroundImageName)
        
        // you can change the content mode:
        imageViewBackground.contentMode = UIViewContentMode.scaleToFill
        
        self.addSubview(imageViewBackground)
        self.sendSubview(toBack: imageViewBackground)
    }
    class func loadFromNibNamed(_ nibNamed: String, bundle : Bundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
}
