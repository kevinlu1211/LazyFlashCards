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
    func fadeIn(duration : NSTimeInterval = 1.0, delay : NSTimeInterval = 0.0, alpha : CGFloat = 1.0, completion: ((Bool) -> Void)? = {(finished: Bool) -> Void in }) {
        UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseIn, animations: {self.alpha = alpha}, completion: completion)
    }
    
    func fadeOut(duration : NSTimeInterval = 1.0, delay : NSTimeInterval = 0.0, alpha : CGFloat = 0.0, completion: ((Bool) -> Void)? = {(finished: Bool) -> Void in }) {
        UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseOut, animations: {self.alpha = alpha}, completion: completion)
    }
    func blurView(duration duration : NSTimeInterval = 1.0, alpha : CGFloat = 1.0, style: UIBlurEffectStyle) {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = alpha
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
        
    }
    func removeEffects() {
        for subview in self.subviews {
            if (subview is UIVisualEffectView) {
                subview.removeFromSuperview()
            }
        }
    }
    func addBackground(backgroundImageName : String!) {
        // screen width and height:
        let width = self.bounds.size.width
        let height = self.bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRectMake(0, 0, width, height))
        imageViewBackground.image = UIImage(named: backgroundImageName)
        
        // you can change the content mode:
        imageViewBackground.contentMode = UIViewContentMode.ScaleToFill
        
        self.addSubview(imageViewBackground)
        self.sendSubviewToBack(imageViewBackground)
    }
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? UIView
    }
}