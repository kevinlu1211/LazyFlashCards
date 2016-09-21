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
    
    override func setExpanded(_ expanded: Bool, animated: Bool) {
        super.setExpanded(expanded, animated: animated)
        
        if !animated {
            toggleCell()
        } else {
            let alwaysOptions: UIViewAnimationOptions = [.allowUserInteraction, .beginFromCurrentState, .transitionCrossDissolve]
            let expandedOptions: UIViewAnimationOptions = [.transitionFlipFromTop, .curveEaseOut]
            let collapsedOptions: UIViewAnimationOptions = [.transitionFlipFromBottom, .curveEaseIn]
            let options: UIViewAnimationOptions = expanded ? alwaysOptions.union(expandedOptions) : alwaysOptions.union(collapsedOptions)
            
            UIView.transition(with: detailView, duration: 0.3, options: options, animations: { () -> Void in
                self.toggleCell()
                }, completion: nil)
        }
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
        detailView.phraseLabel.textColor = theme.getTextColor()
        detailView.pronunciationLabel.textColor = theme.getTextColor()
        detailView.definitionTextView.textColor = theme.getTextColor()
        detailView.backgroundColor = UIColor.clear
    }
    
    // MARK: - Helpers
    
    fileprivate func toggleCell() {
        detailView.isHidden = !expanded
        headerView.imageView.transform = expanded ? CGAffineTransform(rotationAngle: CGFloat(M_PI)) : CGAffineTransform.identity
    }
    
    
}
