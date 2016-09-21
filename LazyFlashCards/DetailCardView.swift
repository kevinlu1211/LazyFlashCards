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
    
    @IBOutlet weak var deleteButton: RoundView!
    @IBOutlet weak var settingsButton: RoundView!
    @IBOutlet weak var settingsButtonImage: UIImageView!
    
    var inSettings = false
    
    var delegate : DetailCardViewDelegate?

    override func awakeFromNib() {
        // First hide the delete and edit buttons
        deleteButton.isHidden = true
        
        let tapSettings = UITapGestureRecognizer(target: self, action: #selector(self.handleSettings))
        let tapDelete = UITapGestureRecognizer(target: self, action: #selector(self.handleDelete))
        settingsButton.addGestureRecognizer(tapSettings)
        deleteButton.addGestureRecognizer(tapDelete)
    }
  
    func handleDelete() {
        deleteButton.respondToTap()
        delegate?.handleDeleteAction(self)
    }
    
    func handleSettings() {
        settingsButton.respondToTap()
        if !inSettings {
            deleteButton.isHidden = false
            settingsButtonImage.image = UIImage(named: ImageName.CHECKMARK_IMAGE_NAME)
            inSettings = true
        }
        else {
            deleteButton.isHidden = true
            settingsButtonImage.image = UIImage(named: ImageName.SETTINGS_IMAGE_NAME)
            inSettings = false
        }
        
    }
}

protocol DetailCardViewDelegate : class {
    func handleDeleteAction(_ detailCardView: DetailCardView)
}

extension DetailCardView {
    internal func getParentTableViewCell() -> CardTableViewCell {
        return (self.superview?.superview as! CardTableViewCell)
    }
}
