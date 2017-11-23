//
//  NSManagedObject+CoreDataProperties.swift
//  ExchangeRatio
//
//  Created by Jakub Buczek on 11/15/17.
//  Copyright © 2017 Jakub Buczek. All rights reserved.
//
//

import Foundation
import CoreData


extension Currency {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NSManagedObject> {
        return NSFetchRequest<NSManagedObject>(entityName: "Currency")
    }

    @NSManaged public var base: String?
    @NSManaged public var date: String?
    @NSManaged public var rates: NSManagedObject?
    
    @objc(addRatesObject:)
    @NSManaged public func addToRates(_ value: Rates)
    
    @objc(addRates:)
    @NSManaged public func addToRates(_ values: NSSet)
}
