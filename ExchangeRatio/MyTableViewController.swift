//
//  MyTableViewController.swift
//  ExchangeRatio
//
//  Created by Jakub Buczek on 11/9/17.
//  Copyright © 2017 Jakub Buczek. All rights reserved.
//

import UIKit

import CoreData

class MyTableViewController: UITableViewController {

    //private var currencies = [Array<Currency>]()
    
    lazy var currencyFetchedResultController : NSFetchedResultsController<NSFetchRequestResult> = getFetchedResultController(entityName: "Currency", sortByKey: "base")
    

    
    @IBAction func refreshRates(_ sender: UIBarButtonItem) {
//        self.coreDataManager.updateData(showAlert: {(title, message) -> Void in
//            self.showAlertWith(title: title, message: message)
//        })
        updateData()
    }

    func getFetchedResultController(entityName: String, sortByKey: String) -> NSFetchedResultsController<NSFetchRequestResult>{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: sortByKey, ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }
    
    private func updateData() {
        do {
            try self.currencyFetchedResultController.performFetch()
            print("Count fetched first: \(String(describing: self.currencyFetchedResultController.sections?[0].numberOfObjects))")
        } catch let error {
            print("ERROR: \(error)")
        }
        
        let service = FixerApi()
        let group = DispatchGroup()
        group.enter()
        self.downloadDataAndSaveinCoreData(withClear: true, service: service, group: group)
        group.notify(queue: .main){
            let rfrc = self.getFetchedResultController(entityName: "Rates", sortByKey: "name")
            do {
                try rfrc.performFetch()
            } catch let error {
                print("ERROR: \(error)")
            }
            if let objects = rfrc.fetchedObjects {
                for case let rate as Rates in objects {
                    group.notify(queue: .main){
                        group.enter()
                        self.downloadDataAndSaveinCoreData(currency: rate.name, withClear: false, service: service,  group: group)
                    }
                }
            }
        }
    }
    
    private func downloadDataAndSaveinCoreData(currency: String? = nil, withClear: Bool, service: FixerApi, group: DispatchGroup){
        service.getDataWith(currency: currency) { (result) in
            switch result {
            case .Success(let data):
                if withClear{self.clearData()}
                self.saveInCoreDataWith(array: [data])
                print(data)
            case .Error(let message):
                DispatchQueue.main.async {
                    self.showAlertWith(title: "Error", message: message)
                }
            }
            group.leave()
        }
    }
    
    
    private func clearData(){
        do {
            let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
            let fetchRequestCurrency = NSFetchRequest<NSFetchRequestResult>(entityName: "Currency")
            let fetchRequestRates = NSFetchRequest<NSFetchRequestResult>(entityName: "Rates")
            do {
                let currencyObjects = try context.fetch(fetchRequestCurrency) as? [NSManagedObject]
                _ = currencyObjects.map{$0.map{context.delete($0)}}
                CoreDataStack.sharedInstance.saveContext()
                let ratesObjects = try context.fetch(fetchRequestRates) as? [NSManagedObject]
                _ = ratesObjects.map{$0.map{context.delete($0)}}
                CoreDataStack.sharedInstance.saveContext()
            } catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
    }
    
    private func saveInCoreDataWith(array: [[String: AnyObject]]) {
        _ = array.map{self.createCurrencyEntityFrom(dictionary: $0)}
        do {
            try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
        } catch let error {
            print(error)
        }
    }
    
    
    
    
    private func createCurrencyEntityFrom(dictionary: [String: AnyObject]) -> NSManagedObject? {
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        let currencyEntity = Currency(context: context)
        
        currencyEntity.base = dictionary["base"] as? String
        currencyEntity.date = dictionary["date"] as? String
        let ratesDictionary = dictionary["rates"] as? [String: Double]
        for (key, value) in ratesDictionary! {
            let ratesEntity = Rates(context: context)
            ratesEntity.name = key
            ratesEntity.value = value
            currencyEntity.addToRates(ratesEntity)
        }
        return nil
    }
    
    func showAlertWith(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: title, style: .default){
            (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }

    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.title = "Exchange rates"
        updateData()
    }
    

    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
//        if let count = self.fetchedResultController.sections?[section].numberOfObjects{
//            return count
//        }
        if let count = currencyFetchedResultController.sections?.first?.numberOfObjects {
            return count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let currency = currencies[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "BaseCell", for: indexPath) as! CurrencyUITableViewCell
        if let currency = currencyFetchedResultController.object(at: indexPath) as? Currency {
            cell.setCurrencyCellWith(currency: currency)
        }
       
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "BaseCell", for: indexPath) as! CurrencyUITableViewCell
//        self.performSegue(withIdentifier: "showDetail", sender: cell.getCurrencyFromCell())
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let ratesViewController = segue.destination as! RatesTableViewController
            if let cell = sender as? CurrencyUITableViewCell{
                ratesViewController.currency = cell.getCurrencyFromCell()
            }
        }
    }

}

extension MyTableViewController: NSFetchedResultsControllerDelegate {
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
