//
//  TestViewController.swift
//  LazyFlashCards
//
//  Created by Kevin Lu on 31/08/2016.
//  Copyright © 2016 Kevin Lu. All rights reserved.
//

import UIKit
import Koloda

class TestViewController: UIViewController {

    @IBOutlet weak var deckView: KolodaView!

    var deck : Deck!
    var flashCards : [FlashCard] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupDeck()
        deckView.dataSource = self
        deckView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setupDeck() {
        deck.createFlashCards()
        if let useableFlashCards = deck.useableFlashCards {
            flashCards = useableFlashCards
        }
    }

}
extension TestViewController: KolodaViewDelegate {
    func kolodaDidRunOutOfCards(koloda: KolodaView) {
        // TODO: Reset flashCards
    }
    
    func koloda(koloda: KolodaView, didSelectCardAtIndex index: UInt) {
        print("selected card \(index)")
    }
}

extension TestViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(koloda:KolodaView) -> UInt {
        return UInt(flashCards.count)
    }
    
    func koloda(koloda: KolodaView, viewForCardAtIndex index: UInt) -> UIView {
        print("hi") 
        return NSBundle.mainBundle().loadNibNamed("CardView", owner: self, options: nil)[0] as! UIView
    }
    
    func koloda(koloda: KolodaView, viewForCardOverlayAtIndex index: UInt) -> OverlayView? {
        print("hihi")
        return NSBundle.mainBundle().loadNibNamed("OverlayView",
                                                  owner: self, options: nil)[0] as? OverlayView
    }
}