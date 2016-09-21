//
//  Deck.swift
//  FlashCards
//
//  Created by Kevin Lu on 30/12/2015.
//  Copyright © 2015 Kevin Lu. All rights reserved.
//

import Foundation
import CoreData
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class Deck : NSManagedObject {
    @NSManaged var name : String!
    @NSManaged var detail : String?
    @NSManaged var flashCards : NSSet?
    var useableFlashCards : [FlashCard]?
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(context : NSManagedObjectContext, name : String, detail : String?) {
        let entity = NSEntityDescription.entity(forEntityName: "Deck", in: context)
        super.init(entity: entity!, insertInto: context)
        self.name = name
        if detail != nil {
            self.detail = detail
        }
    }
    
    func createFlashCards() {
        let unsortedUseableFlashCards = self.flashCards?.allObjects as? [FlashCard]
        let sortedUseableFlashCards = unsortedUseableFlashCards?.sorted{$0.phrase < $1.phrase}
        print("created new flash cards")
        useableFlashCards = sortedUseableFlashCards
        print(useableFlashCards?.count)

    }
    
    func getCard(_ index : Int) -> FlashCard {
        return self.useableFlashCards![index]
    }
}

extension Array
{
    /** Randomizes the order of an array's elements. */
    mutating func shuffle(_ numberOfCards : Int)
    {
        for _ in 0..<numberOfCards
        {
            sort { (_,_) in arc4random() < arc4random() }
        }
    }
}
