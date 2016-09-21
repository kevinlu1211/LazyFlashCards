//
//  CustomTableViewCell.swift
//  AEAccordion
//
//  Created by Marko Tadic on 6/26/15.
//  Copyright © 2015 AE. All rights reserved.
//

import UIKit
import AEAccordion


class DeckTableViewCell: AEAccordionTableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var headerView: HeaderView! 
    @IBOutlet weak var detailView: DetailDeckView!
    
    // MARK: - Variables 
    var theme : ThemeStrategy {
        return ThemeFactory.sharedInstance().getTheme()
    }
    
    // MARK: - Override
    
    override func setExpanded(_ expanded: Bool, animated: Bool) {
        super.setExpanded(expanded, animated: animated)
        
        if !animated {
            toggleCell()
        } else {
            let alwaysOptions: UIViewAnimationOptions = [.allowUserInteraction, .beginFromCurrentState, .transitionCrossDissolve]
            let expandedOptions: UIViewAnimationOptions = [.transitionFlipFromTop, .curveEaseOut]
            let collapsedOptions: UIViewAnimationOptions = [.transitionFlipFromBottom, .curveEaseIn]
            let options: UIViewAnimationOptions = expanded ? alwaysOptions.union(expandedOptions) : alwaysOptions.union(collapsedOptions)
            
            UIView.transition(with: detailView, duration: 0.2, options: options, animations: { () -> Void in
                self.toggleCell()
                }, completion: nil)
        }
    }
    
    
    
    
    // MARK: - Helpers
    
    fileprivate func toggleCell() {
        detailView.isHidden = !expanded
        headerView.imageView.transform = expanded ? CGAffineTransform(rotationAngle: CGFloat(M_PI)) : CGAffineTransform.identity
    }
    
    func setup() {
        // Setup background
        backgroundColor = theme.getDarkColor()
        selectionStyle = UITableViewCellSelectionStyle.none
        
        // Setup header view
        headerView.contentView.layer.cornerRadius = theme.getCornerRadiusForView()
        headerView.contentView.backgroundColor = theme.getMediumColor()
        headerView.titleLabel.textColor = theme.getTextColor()
        headerView.backgroundColor = UIColor.clear
        
        detailView.contentView.layer.cornerRadius = theme.getCornerRadiusForView()
        detailView.contentView.backgroundColor = theme.getLightColor()
        detailView.backgroundColor = UIColor.clear
    }
    
}

// MARK: - Overriding responder chain
extension DeckTableViewCell{
    
    // Redirect which view is supposed to recieve the touch notification
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        print("---------- CustomTableViewCell hitTest ----------")

        print("My superview is \(self.superview)")
        
        let hitView = super.hitTest(point, with: event)
        print("The class that this method is called from is \(NSStringFromClass(type(of: self)))")

        // if the hitView is the viewCell then don't return it as it will be the view is passed down the chain responder
        if (hitView == self) {
            print("The hitview is self")
            return nil
        }
        else {
            if let hitView = hitView {
                print("The class that this method is called from is \(NSStringFromClass(type(of: self)))")
                print("The hitView is: \(NSStringFromClass(type(of: hitView)))")
                print("The hitView tag is: \(hitView.tag)")
                print("The hitView pointer address is: \(hitView.description)")
                
                // By not returning the view attached to the CustomTableViewCell, we avoid hiding the cell everytime it's tapped. So we only return a view if it is the top bar view, or if it's the button.
                if (hitView.isKind(of: RoundView.self) || hitView.isKind(of: HeaderViewDefaultView.self)) {
                    return hitView
                }
                else {
                    return nil
                }
            }
            else {
                print("There are no subviews under this view")
                return nil
            }
        }
    }
}
