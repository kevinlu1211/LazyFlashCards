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
    
    @IBOutlet weak var headerView: HeaderView! {
        didSet {
            headerView.imageView.tintColor = UIColor.whiteColor()
        }
    }
    @IBOutlet weak var detailView: DetailDeckView!
    
    // MARK: - Variables 
    lazy var theme : ThemeStrategy = (UIApplication.sharedApplication().delegate as! AppDelegate).themeStrategy

    // MARK: - Override
    
    override func setExpanded(expanded: Bool, animated: Bool) {
        super.setExpanded(expanded, animated: animated)
        
        if !animated {
            toggleCell()
        } else {
            let alwaysOptions: UIViewAnimationOptions = [.AllowUserInteraction, .BeginFromCurrentState, .TransitionCrossDissolve]
            let expandedOptions: UIViewAnimationOptions = [.TransitionFlipFromTop, .CurveEaseOut]
            let collapsedOptions: UIViewAnimationOptions = [.TransitionFlipFromBottom, .CurveEaseIn]
            let options: UIViewAnimationOptions = expanded ? alwaysOptions.union(expandedOptions) : alwaysOptions.union(collapsedOptions)
            
            UIView.transitionWithView(detailView, duration: 0.3, options: options, animations: { () -> Void in
                self.toggleCell()
                }, completion: nil)
        }
    }
    
    
    
    
    // MARK: - Helpers
    
    private func toggleCell() {
        detailView.hidden = !expanded
        headerView.imageView.transform = expanded ? CGAffineTransformMakeRotation(CGFloat(M_PI)) : CGAffineTransformIdentity
    }
    
    func setup() {
        // Setup background
        backgroundColor = theme.getBackgroundColor()
        selectionStyle = UITableViewCellSelectionStyle.None
        
        // Setup header view
        headerView.contentView.layer.cornerRadius = theme.getCornerRadiusForView()
        headerView.titleLabel.textColor = theme.getTextColor()
        headerView.backgroundColor = theme.getHeaderViewColor()
        
        detailView.contentView.layer.cornerRadius = theme.getCornerRadiusForView()
        detailView.contentView.backgroundColor = theme.getDetailViewColor()
    }
    
}

// MARK: - Overriding responder chain
extension DeckTableViewCell{
    
    // Redirect which view is supposed to recieve the touch notification
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        print("---------- CustomTableViewCell hitTest ----------")

        print("My superview is \(self.superview)")
        
        let hitView = super.hitTest(point, withEvent: event)
        print("The class that this method is called from is \(NSStringFromClass(self.dynamicType))")

        // if the hitView is the viewCell then don't return it as it will be the view is passed down the chain responder
        if (hitView == self) {
            print("The hitview is self")
            return nil
        }
        else {
            if let hitView = hitView {
                print("The class that this method is called from is \(NSStringFromClass(self.dynamicType))")
                print("The hitView is: \(NSStringFromClass(hitView.dynamicType))")
                print("The hitView tag is: \(hitView.tag)")
                print("The hitView pointer address is: \(hitView.description)")
                
                // By not returning the view attached to the CustomTableViewCell, we avoid hiding the cell everytime it's tapped. So we only return a view if it is the top bar view, or if it's the button.
                if (hitView.isKindOfClass(UIButton) || hitView.isKindOfClass(HeaderViewDefaultView)) {
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