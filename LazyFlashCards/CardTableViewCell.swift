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

    @IBOutlet weak var headerView: HeaderView!
    
    @IBOutlet weak var detailView: DetailCardView!
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

}
