//
//  CardTableViewCell.swift
//  LazyFlashCards
//
//  Created by Kevin Lu on 30/08/2016.
//  Copyright © 2016 Kevin Lu. All rights reserved.
//

import UIKit
import AEAccordion
class CardTableViewCell: AEAccordionTableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var detailView: DetailCardView!
    
    // MARK: - Variables
    var theme : ThemeStrategy {
        return ThemeFactory.sharedInstance().getTheme()
    }
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
    
    func setup() {
        // Setup background
        backgroundColor = theme.getDarkColor()
        selectionStyle = UITableViewCellSelectionStyle.None
        
        // Setup header view
        headerView.contentView.layer.cornerRadius = theme.getCornerRadiusForView()
        headerView.contentView.backgroundColor = theme.getMediumColor()
        headerView.titleLabel.textColor = theme.getTextColor()
        headerView.backgroundColor = UIColor.clearColor()
    
        
        detailView.contentView.layer.cornerRadius = theme.getCornerRadiusForView()
        detailView.contentView.backgroundColor = theme.getLightColor()
        detailView.phraseLabel.textColor = theme.getTextColor()
        detailView.pronunciationLabel.textColor = theme.getTextColor()
        detailView.definitionTextView.textColor = theme.getTextColor()
        detailView.backgroundColor = UIColor.clearColor()
    }
    
    // MARK: - Helpers
    
    private func toggleCell() {
        detailView.hidden = !expanded
        headerView.imageView.transform = expanded ? CGAffineTransformMakeRotation(CGFloat(M_PI)) : CGAffineTransformIdentity
    }
    
    
}
