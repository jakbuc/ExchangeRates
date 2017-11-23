//
//  Rates+CoreDataProperties.swift
//  ExchangeRatio
//
//  Created by Jakub Buczek on 11/15/17.
//  Copyright © 2017 Jakub Buczek. All rights reserved.
//
//

import Foundation
import CoreData


extension Rates {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Rates> {
        return NSFetchRequest<Rates>(entityName: "Rates")
    }

    @NSManaged public var name: String?
    @NSManaged public var value: Double
    @NSManaged public var base: NSManagedObject?

}
