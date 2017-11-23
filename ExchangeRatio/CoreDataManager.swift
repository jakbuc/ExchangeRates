//
//  CoreDataManager.swift
//  ExchangeRatio
//
//  Created by Jakub Buczek on 11/17/17.
//  Copyright © 2017 Jakub Buczek. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager{
    
//    public typealias showAlertWithHandler = (_ title : String, _ message: String) -> ()
//    
//    static let sharedInstance = CoreDataManager()
//    
//    lazy var fetchedResultController: NSFetchedResultsController<NSFetchRequestResult> = {
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Currency.self))
//        //let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Currency.fetchRequest()
//        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "base", ascending: true)]
//        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
//        //frc.delegate = self
//        return frc
//    }()
//    
//    public func updateData(showAlert: @escaping showAlertWithHandler) {
//        do {
//            try self.fetchedResultController.performFetch()
//            print("Count fetched first: \(self.fetchedResultController.sections?[0].numberOfObjects)")
//        } catch let error {
//            print("ERROR: \(error)")
//        }
//        
//        let service = FixerApi()
//        service.getDataWith { (result) in
//            switch result {
//            case .Success(let data):
//                self.clearData()
//                self.saveInCoreDataWith(array: [data])
//                print(data)
//            case .Error(let message):
//                DispatchQueue.main.async {
//                    showAlert("Error", message)
//                }
//            }}
//    }
//    
//    private func clearData(){
//        do {
//            let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
//            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Currency")
//            do {
//                let objects = try context.fetch(fetchRequest) as? [NSManagedObject]
//                _ = objects.map{$0.map{context.delete($0)}}
//                CoreDataStack.sharedInstance.saveContext()
//            } catch let error {
//                print("ERROR DELETING : \(error)")
//            }
//        }
//    }
//    
//    private func saveInCoreDataWith(array: [[String: AnyObject]]) {
//        _ = array.map{self.createCurrencyEntityFrom(dictionary: $0)}
//        do {
//            try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
//        } catch let error {
//            print(error)
//        }
//    }
//    
//    
//
//    
//    private func createCurrencyEntityFrom(dictionary: [String: AnyObject]) -> NSManagedObject? {
//        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
//        let currencyEntity = Currency(context: context)
//        
//        currencyEntity.base = dictionary["base"] as? String
//        currencyEntity.date = dictionary["date"] as? String
//        let ratesDictionary = dictionary["rates"] as? [String: Double]
//        for (key, value) in ratesDictionary! {
//            let ratesEntity = Rates(context: context)
//            ratesEntity.name = key
//            ratesEntity.value = value
//            currencyEntity.addToRates(ratesEntity)
//        }
//        return nil
//    }
//    
//    
    
    
}
