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
    var swipedLeftFlashCards : [FlashCard] = []
    
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
    
    func koloda(koloda: KolodaView, didSwipeCardAtIndex index: UInt, inDirection direction: SwipeResultDirection) {
        let currentCard = flashCards[Int(index)]
        if(direction == .Left) {
            print("swiped card \(index) left ")
            swipedLeftFlashCards.append(currentCard)

        }
        else if (direction == .Right) {
            print("swiped card \(index) right")
        }
    }
    
    func koloda(koloda: KolodaView, draggedCardWithPercentage finishPercentage: CGFloat, inDirection direction: SwipeResultDirection) {
        if (direction == .Left) {
            print(koloda.currentCardIndex)
            print(finishPercentage)
        }
        
    }



}

extension TestViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(koloda:KolodaView) -> UInt {
        return UInt(flashCards.count)
    }
    
    func koloda(koloda: KolodaView, viewForCardAtIndex index: UInt) -> UIView {
        print("hi")
        let cardView = UINib(nibName: "CardView", bundle: nil).instantiateWithOwner(nil, options: nil).first as! CardView
//        cardView.phraseLabel.text = flashCards[Int(index)].phrase
        cardView.front.alpha = 1
//        cardView.front.phraseLabel.text = "HI"
//        cardView.back.alpha = 0
        cardView.layer.cornerRadius = 10
//        return cardView
        return cardView
    }
    
    
//    func koloda(koloda: KolodaView, viewForCardOverlayAtIndex index: UInt) -> OverlayView? {
//        print("hihi")
//        return NSBundle.mainBundle().loadNibNamed("OverlayView",
//                                                  owner: self, options: nil)[0] as? OverlayView
//    }
}