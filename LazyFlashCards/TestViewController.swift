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
    
    override func viewDidLayoutSubviews() {
        print("viewDidLayoutSubviews cardView.frame before reloading data is: \(deckView.frame)")
//        deckView.reloadData()
//        deckView.reloadData()
//        print("viewDidLayoutSubviews cardView.frame after reloading data is: \(deckView.frame)")
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
        print(finishPercentage)
        if (direction == .Left) {
            
            let cardView = koloda.viewForCardAtIndex(koloda.currentCardIndex) as! CardView
            let decimalFinishPercentage = finishPercentage/100
            
            // -TODO: Don't use linear alpha change use exponential, so slow at the start but fast at the end
            cardView.front.alpha = 1-decimalFinishPercentage
            cardView.back.alpha = decimalFinishPercentage
//            print(koloda.currentCardIndex)
//            print(finishPercentage)
        }
        
    }
    
    func kolodaDidResetCard(koloda: KolodaView) {
        let cardView = koloda.viewForCardAtIndex(koloda.currentCardIndex) as! CardView    
        cardView.front.alpha = 1
        cardView.back.alpha = 0
    }

}

extension TestViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(koloda:KolodaView) -> UInt {
        return UInt(flashCards.count)
    }
    
    func koloda(koloda: KolodaView, viewForCardAtIndex index: UInt) -> UIView {
        // Note that the commented out code below worked because our top level view of the CardView.xib was of class CardView, but now that we have changed it into a UIView it won't work this is because UINib(...)[0] will always get the top level view in the hierarchy
//        let cardView = UINib(nibName: "CardView", bundle: nil).instantiateWithOwner(nil, options: nil).first as! CardView
//        return cardView
//        print("koloda frame is: \(koloda.frame)")
//        let view = UIView(frame:koloda.frame)
//        view.backgroundColor = UIColor.blueColor()
        let view = CardView(frame : koloda.bounds)
        let card = flashCards[Int(index)]
        // Setup card front
        view.front.alpha = 1
        view.front.phraseLabel.text = card.phrase
        view.userInteractionEnabled = false
        
        // Set card back
        view.back.alpha = 0
        view.back.pronunciationLabel.text = card.pronunciation
        view.back.definitionTextField.text = card.definition
        view.userInteractionEnabled = false
        
        return view
    }
    
    
//    func koloda(koloda: KolodaView, viewForCardOverlayAtIndex index: UInt) -> OverlayView? {
//        print("hihi")
//        return NSBundle.mainBundle().loadNibNamed("OverlayView",
//                                                  owner: self, options: nil)[0] as? OverlayView
//    }
}