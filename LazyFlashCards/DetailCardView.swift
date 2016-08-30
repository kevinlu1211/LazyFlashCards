//
//  DetailCardView.swift
//  LazyFlashCards
//
//  Created by Kevin Lu on 29/08/2016.
//  Copyright © 2016 Kevin Lu. All rights reserved.
//

import UIKit
import AEXibceptionView

class DetailCardView: AEXibceptionView {

    @IBOutlet weak var phraseLabel: UILabel!
    @IBOutlet weak var pronunciationLabel: UILabel!

    @IBOutlet weak var definitionTextView: UITextView!
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    @IBAction func editButtonAction(sender: AnyObject) {
    }

    @IBAction func deleteButtonAction(sender: AnyObject) {
    }
}
