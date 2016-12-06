//
//  Card+CoreDataProperties.swift
//  MTGPrices
//
//  Created by Gabriele Pregadio on 11/30/16.
//  Copyright © 2016 Gabriele Pregadio. All rights reserved.
//

import Foundation
import CoreData

extension Card {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Card> {
        return NSFetchRequest<Card>(entityName: "Card");
    }

    @NSManaged public var amount: Int16
    @NSManaged public var cmc: String
    @NSManaged public var id: String
    @NSManaged public var imageUrl: String?
    @NSManaged public var manaCost: String?
    @NSManaged public var name: String
    @NSManaged public var power: String?
    @NSManaged public var rarity: String
    @NSManaged public var set: String
    @NSManaged public var text: String?
    @NSManaged public var toughness: String?
    @NSManaged public var type: String
    @NSManaged public var colors: String?
    @NSManaged public var deck: Deck

}
