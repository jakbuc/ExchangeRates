//
//  FixerApi.swift
//  ExchangeRatio
//
//  Created by Jakub Buczek on 11/9/17.
//  Copyright © 2017 Jakub Buczek. All rights reserved.
//

import Foundation
import UIKit
import CoreData

public class FixerApi : NSObject{

    struct Query {
        var currency: String?
        var request: String
        var endpoint: String
        
        init(currency curr: String?){
            currency = curr
            if let base = currency {
                request = "latest?base=\(base)"
            }
            else{
                request = "latest"
            }
            endpoint = "https://api.fixer.io/\(request)"
        }
    }
//    let queryLatest = "latest"
//
//    lazy var endpoint: String = { return "https://api.fixer.io/\(self.query)"}()
    
    
    func getDataWith(currency: String? = nil, completion: @escaping (Result<[String: AnyObject]>) -> Void) {
        let query = Query(currency: currency)
        guard let url = URL(string: query.endpoint) else { return completion(.Error("Invalid URL"))}
        
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else { return completion(.Error(error!.localizedDescription))}
            guard let data = data else { return completion(.Error(error?.localizedDescription ?? "There are no new items to show"))}
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [String: AnyObject] {
                    DispatchQueue.main.async {
                        completion(.Success(json))
                    }
                }
            } catch let error  {
                completion(.Error(error.localizedDescription))
            }
        }.resume()
    }
    
    
    
    
//    static let baseUrl = "https://api.fixer.io/"
//
//    var currencyEntities: [NSManagedObject] = []
//
//
//    enum BackendError: Error{
//        case urlError(reason: String)
//        case objectSerialization(reason: String)
//    }
//
//    static func endpointForExchangeRatio(for currency  : String) -> String{
//        return "\(baseUrl)latest?base=\(currency)"
//    }
//
//    public func getAllAvailableCurrencies(){
//
//    }
//    static func getExchangeRates(for currencyName: String) -> Currencies?{
//
//        let endpoint = Currencies.endpointForExchangeRatio(for: currencyName)
//        var downloadedCurrency: Currencies? = nil
//        makeHTTPGetRequest(endpoint: endpoint, completionHandler: { (currency, error) in
//            if let error = error {
//                print(error)
//                return
//            }
//            guard let currency = currency else {
//                print("Error getting first currency: result is nil")
//                return
//            }
//            debugPrint(currency)
//            print(currency.base)
//            downloadedCurrency = currency
//            save(currency: currency)
//            //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dataUpdated"), object: nil)
//        })
//        return downloadedCurrency
//    }
//
//    private static func makeHTTPGetRequest(endpoint: String, completionHandler: @escaping (Currencies?, Error?) -> Void){
//        guard let url = URL(string: endpoint) else{
//            let error = BackendError.urlError(reason: "Could not create URL")
//            completionHandler(nil, error)
//            return
//        }
//
//        let urlRequest = URLRequest(url: url)
//
//        let session = URLSession.shared
//        let task = session.dataTask(with: urlRequest, completionHandler: {
//            (data, response, error) in
//            guard error == nil else{
//                completionHandler(nil, error!)
//                return
//            }
//
//            guard let responseData = data else{
//                let error = BackendError.objectSerialization(reason: "No data in response")
//                completionHandler(nil, error)
//                return
//            }
//
//            let decoder = JSONDecoder()
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd"
//            decoder.dateDecodingStrategy = .formatted(dateFormatter)
//            do {
//                let todo = try decoder.decode(Currencies.self, from: responseData)
//                completionHandler(todo, nil)
//            } catch {
//                print("error trying to convert data to JSON")
//                print(error)
//                completionHandler(nil, error)
//
//            }
//        })
//        task.resume()
//    }
//
//    static func save(currency: Currencies) {
//
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//
//        let managedContext = appDelegate.persistentContainer.viewContext
//
//        let entity = NSEntityDescription.entity(forEntityName: "Currency", in: managedContext)!
//        let newCurrency = NSManagedObject(entity: entity, insertInto: managedContext)
//
//        newCurrency.setValue(currency.base, forKeyPath: "base")
//
//        do {
//            try managedContext.save()
//            //currencies.append(currency)
//        }
//        catch let error as NSError {
//            print ("Could not save. \(error), \(error.userInfo)")
//        }
//
//    }
    
}
enum Result <T>{
    case Success(T)
    case Error(String)
}

