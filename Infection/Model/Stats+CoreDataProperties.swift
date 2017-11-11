//
//  Stats+CoreDataProperties.swift
//  Infection
//
//  Created by Donald Timpson on 11/10/17.
//  Copyright © 2017 Kraig Wastlund. All rights reserved.
//
//

import Foundation
import CoreData


extension Stats {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Stats> {
        return NSFetchRequest<Stats>(entityName: "Stats")
    }

    @NSManaged public var gamesPlayed: Int32
    @NSManaged public var playerskilled: Int32
    @NSManaged public var killed: Int32
    @NSManaged public var bulletsShot: Int32
    @NSManaged public var bulletsHit: Int32
    @NSManaged public var gamesWon: Int32

}
