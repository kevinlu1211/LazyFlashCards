//
//  FlashCard.swift
//  FlashCards
//
//  Created by Kevin Lu on 30/12/2015.
//  Copyright © 2015 Kevin Lu. All rights reserved.
//

import Foundation
import CoreData

class FlashCard : NSManagedObject {
    @NSManaged var phrase : String?
    @NSManaged var definition : String?
    @NSManaged var pronunciation : String?
    @NSManaged var deck : Deck?
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    init(context : NSManagedObjectContext, phrase : String, pronunciation : String, definition : String) {
        let entity = NSEntityDescription.entity(forEntityName: "FlashCard", in: context)
        super.init(entity: entity!, insertInto: context)
        self.phrase = phrase
        self.pronunciation = pronunciation
        self.definition = definition
        
        
    }
    
    func isEqualInContent(_ object: AnyObject?) -> Bool {
        print(self.phrase!)
        print(self.pronunciation!)
        print(self.definition!)
        print(object!.phrase)
        print(object?.pronunciation)
        if object!.phrase == self.phrase! && object!.definition == self.definition! && object!.pronunciation == self.pronunciation! {
            return true
        }
        else {
            return false
        }
    }
}
