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
    @IBOutlet weak var settingsButtonView: RoundView!
    
    
    func handleViewDeck() {
        deckButtonView.respondToTap()
        delegate?.handleViewDeck(self)
    }
    func handleTest() {
        testButtonView.respondToTap()
        delegate?.handleTest(self)
    }
    func handleDelete() {
        settingsButtonView.respondToTap()
        delegate?.handleSettings(self)

    }
    
    override func awakeFromNib() {
        let tapDeck = UITapGestureRecognizer(target: self, action: #selector(self.handleViewDeck))
        let tapTest = UITapGestureRecognizer(target: self, action: #selector(self.handleTest))
        let tapDelete = UITapGestureRecognizer(target: self, action: #selector(self.handleDelete))
        deckButtonView.addGestureRecognizer(tapDeck)
        testButtonView.addGestureRecognizer(tapTest)
        settingsButtonView.addGestureRecognizer(tapDelete)
    }
}

protocol DetailDeckViewDelegate : class {
    func handleViewDeck(_ detailDeckView : DetailDeckView)
    func handleTest(_ detailDeckView : DetailDeckView)
    func handleSettings(_ detailDeckView : DetailDeckView)
}

extension DetailDeckView {
    internal func getParentTableViewCell() -> DeckTableViewCell {
        return (self.superview?.superview as! DeckTableViewCell)
    }
}
