//
//  TestViewController.swift
//  LazyFlashCards
//
//  Created by Kevin Lu on 31/08/2016.
//  Copyright © 2016 Kevin Lu. All rights reserved.
//

import UIKit
import Koloda
import SwiftyButton

class TestViewController: UIViewController {

    @IBOutlet weak var deckView: KolodaView!

    var deck : Deck!
    var flashCards : [FlashCard] = []
    var swipedLeftFlashCards : [FlashCard] = []
    var initialCardNumber : Int!
    var theme : ThemeStrategy {
        return ThemeFactory.sharedInstance().getTheme()
    }
    
    @IBOutlet weak var restartButton: RoundView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        setupDataSource()
        setupDeckView()
        setupButton()
        self.view.backgroundColor = theme.getLightColor()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setupDataSource() {
        if let flashCards = deck.useableFlashCards {
            self.flashCards = flashCards
        }
        else {
            deck.createFlashCards()
            if let flashCards = deck.useableFlashCards {
                self.flashCards = flashCards
            }
        }
        
        initialCardNumber = flashCards.count
        print("shuffling flash cards")
        flashCards.shuffle(initialCardNumber)
    }
    
    func setupDeckView() {
        deckView.delegate = self
        deckView.dataSource = self
    }
    
    func setupButton() {
        restartButton.isHidden = true
        let tapRestart = UITapGestureRecognizer(target: self, action: #selector(self.handleRestart))
        restartButton.addGestureRecognizer(tapRestart)
        
    }
    
    func handleRestart() {
        setupDataSource()
        deckView.resetCurrentCardIndex()
        restartButton.isHidden = true
    }
    


}
extension TestViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        // Before restart, clear away the old data
        flashCards.removeFirst(initialCardNumber)
        
        // Setup the new number of cards in this iteration of testing
        initialCardNumber = flashCards.count
        
        // Shuffle the cards
        flashCards.shuffle(initialCardNumber)
        
        if (initialCardNumber == 0) {
            restartButton.isHidden = false
            self.view.bringSubview(toFront: restartButton)
        }
        else {
            deckView.resetCurrentCardIndex()
        }
        
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAtIndex index: UInt) {
        print("selected card \(index)")
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAtIndex index: UInt, inDirection direction: SwipeResultDirection) {
        let currentCard = flashCards[Int(index)]
        
        for fc in flashCards {
            print(fc.phrase)
        }
        
        if(direction == .Left) {
            print("appending \(currentCard.phrase)")
            flashCards.append(currentCard)
            
            for fc in flashCards {
                print(fc.phrase)
            }

        }
        else if (direction == .Right) {
            print("swiped card \(index) right")
        }
    }
    
    func koloda(_ koloda: KolodaView, draggedCardWithPercentage finishPercentage: CGFloat, inDirection direction: SwipeResultDirection) {
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
    
    func kolodaDidResetCard(_ koloda: KolodaView) {
        let cardView = koloda.viewForCardAtIndex(koloda.currentCardIndex) as! CardView    
        cardView.front.alpha = 1
        cardView.back.alpha = 0
    }

}

extension TestViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda:KolodaView) -> UInt {
        return UInt(flashCards.count)
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAtIndex index: UInt) -> UIView {
        // Note that the commented out code below worked because our top level view of the CardView.xib was of class CardView, but now that we have changed it into a UIView it won't work this is because UINib(...)[0] will always get the top level view in the hierarchy
//        let cardView = UINib(nibName: "CardView", bundle: nil).instantiateWithOwner(nil, options: nil).first as! CardView
//        return cardView

        let view = CardView(frame : koloda.bounds)
        let card = flashCards[Int(index)]
        
        // Setup card front
        view.front.phraseLabel.text = card.phrase
        
        // Set card back
        view.back.pronunciationLabel.text = card.pronunciation
        view.back.definitionTextField.text = card.definition

        // Set view aesthestic
        view.setup()
        
        return view
    }
    
    
//    func koloda(koloda: KolodaView, viewForCardOverlayAtIndex index: UInt) -> OverlayView? {
//        print("hihi")
//        return NSBundle.mainBundle().loadNibNamed("OverlayView",
//                                                  owner: self, options: nil)[0] as? OverlayView
//    }
}
