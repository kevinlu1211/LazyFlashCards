//
//  CardView.swift
//  LazyFlashCards
//
//  Created by Kevin Lu on 31/08/2016.
//  Copyright © 2016 Kevin Lu. All rights reserved.
//

import UIKit

class CardView: UIView {

    @IBOutlet weak var phraseLabel: UILabel!
    
    
    // Our custom view from the XIB file
    var view: UIView!
    
    @IBOutlet weak var front: CardFront!
    @IBOutlet weak var back: CardBack!
    
    override init(frame: CGRect) {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)

        // 3. Setup view from .xib file
        xibSetup()
//        front.backgroundColor = UIColor.greenColor()
//        view.addSubview(front.view)
//        front.view.frame = view.bounds

    }
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here

        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        xibSetup()
//        front = CardFront(frame: view.bounds)
//        front.backgroundColor = UIColor.greenColor()
//        view.addSubview(front)


    }
    
    func xibSetup() {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
//        view.clipsToBounds = true
        
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "CardView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }

}
