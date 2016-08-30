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

class DetailDeckView: AEXibceptionView {
    var delegate : ViewDecksController?

    // MARK: - Outlets
    @IBAction func handleButton(sender: AnyObject) {
        delegate?.handleButton(self)
    }
    
}

protocol DetailViewProtocol : class {
    func handleButton(detailView : DetailDeckView)
}

extension DetailDeckView {
    internal func getParentTableViewCell() -> DeckTableViewCell {
        return (self.superview?.superview as! DeckTableViewCell)
    }
}
