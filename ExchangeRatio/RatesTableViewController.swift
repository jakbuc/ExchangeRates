//
//  RatesTableViewController.swift
//  ExchangeRatio
//
//  Created by Jakub Buczek on 11/20/17.
//  Copyright © 2017 Jakub Buczek. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class RatesTableViewController : UITableViewController{
    
    var currency: Currency? {
        didSet {
            fetchRates()
        }
    }
    var rates: [String: Double] = [:]
//    func getFetchedResultController(entityName: String, sortByKey: String) -> NSFetchedResultsController<NSFetchRequestResult>{
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
//        fetchRequest.sortDescriptors = [NSSortDescriptor(key: sortByKey, ascending: true)]
//        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
//        frc.delegate = self
//        return frc
//    }
    
    func fetchRates(){
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Rates")
        let predicate = NSPredicate(format: "%K == %@", "base", currency!)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        do {
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]

            for managedObject in result {
                if case let base as String = managedObject.value(forKey: "name"), case let value as Double = managedObject.value(forKey: "value") {
                    rates[base] = value
                }
            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }
    override func viewWillAppear(_ animated: Bool){
        navigationItem.title = currency!.base!
    }
    override func viewDidLoad(){
        super.viewDidLoad()
        if let currency = self.currency {
            navigationItem.title = currency.base!
        }
        else{
            self.title = "No data"
        }
//        fetchRates()

    }
    
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return rates.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let currency = currencies[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "RateCell", for: indexPath) as! UITableViewCell
        let index = indexPath.row
        let base = Array(rates.keys)[index]
        cell.textLabel?.text = base
        if let rate = rates[base] {
            cell.detailTextLabel?.text = "\(rate)"
        }
        
        
        return cell
    }
    
}

extension RatesTableViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller:
        NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            self.tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            self.tableView.deleteRows(at: [indexPath!], with: .automatic)
        default:
            break
        }
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
}
