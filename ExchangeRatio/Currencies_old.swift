//
//  Currency.swift
//  ExchangeRatio
//
//  Created by Jakub Buczek on 11/9/17.
//  Copyright © 2017 Jakub Buczek. All rights reserved.
//

import Foundation
import CoreData

extension CodingUserInfoKey{
    public static let context = CodingUserInfoKey(rawValue: "context")!
}

    class Currencies : NSManagedObject, Codable
    {
        
        @NSManaged var base: NSString?
        @NSManaged var date: NSString?
        @NSManaged var rates: NSSet?
        
        enum CodingKeys: String, CodingKey {
            case base = "base"
            case date = "date"
            case rates = "rates"
        }
        
        public func encode(to encoder: Encoder) throws{
            var container = encoder.singleValueContainer()
            try container.encode(self)
        }
        
//        public static func endpointForExchangeRatio(for currency  : String) -> String{
//            return "\(FixerApi.baseUrl)latest?base=\(currency)"
//        }
        
        
        required convenience init(from decoder: Decoder) throws {

            guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else { fatalError()}
            guard let entity = NSEntityDescription.entity(forEntityName: "MyManagedObject", in: context) else { fatalError()}
            
            self.init(entity: entity, insertInto: context)
            
            let container = try decoder.container(keyedBy: CodingKeys.self)
//            try self.base = container.decodeIfPresent(NSString).self, forKey: .base)
//            try self.date = container.decodeIfPresent(NSString.self, forKey: .date)
//            try self.rates = container.decodeIfPresent(NSSet.self, forKey: .rates)
        }
        
    }


