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
    var delegate : DetailDeckViewDelegate?

    // MARK: - Outlets
    @IBAction func handleViewDeck(sender: AnyObject) {
        delegate?.handleViewDeck(self)
    }
    @IBAction func handleTest(sender: AnyObject) {
        delegate?.handleTest(self)
    }
    @IBAction func handleDelete(sender: AnyObject) {
        delegate?.handleDelete(self)

    }
    
}

protocol DetailDeckViewDelegate : class {
    func handleViewDeck(detailDeckView : DetailDeckView)
    func handleTest(detailDeckView : DetailDeckView)
    func handleDelete(detailDeckView : DetailDeckView)
}

extension DetailDeckView {
    internal func getParentTableViewCell() -> DeckTableViewCell {
        return (self.superview?.superview as! DeckTableViewCell)
    }
}
