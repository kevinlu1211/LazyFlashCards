//
//  DetailView.swift
//  AEAccordion
//
//  Created by Marko Tadic on 6/26/15.
//  Copyright © 2015 AE. All rights reserved.
//

import UIKit
import AEXibceptionView
import AEAccordion

class DetailView: AEXibceptionView {
    var delegate : ViewDecksController?

    // MARK: - Outlets
    @IBAction func handleButton(sender: AnyObject) {
        delegate?.handleButton(self)
    }
    
}

protocol DetailViewProtocol : class {
    func handleButton(detailView : DetailView)
}

extension DetailView {
    internal func getParentTableViewCell() -> CustomTableViewCell {
        return (self.superview?.superview as! CustomTableViewCell)
    }
}
