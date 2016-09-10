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
    @IBOutlet weak var deckButtonView: RoundView!
    @IBOutlet weak var testButtonView: RoundView!
    @IBOutlet weak var deleteButtonView: RoundView!
    
    
    func handleViewDeck() {
        deckButtonView.respondToTap()
        delegate?.handleViewDeck(self)
    }
    func handleTest() {
        testButtonView.respondToTap()
        delegate?.handleTest(self)
    }
    func handleDelete() {
        deleteButtonView.respondToTap()
        delegate?.handleDelete(self)

    }
    
    override func awakeFromNib() {
        let tapDeck = UITapGestureRecognizer(target: self, action: #selector(self.handleViewDeck))
        let tapTest = UITapGestureRecognizer(target: self, action: #selector(self.handleTest))
        let tapDelete = UITapGestureRecognizer(target: self, action: #selector(self.handleDelete))
        deckButtonView.addGestureRecognizer(tapDeck)
        testButtonView.addGestureRecognizer(tapTest)
        deleteButtonView.addGestureRecognizer(tapDelete)
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
