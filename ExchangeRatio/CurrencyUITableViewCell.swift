//
//  CurrencyUITableViewCell.swift
//  ExchangeRatio
//
//  Created by Jakub Buczek on 11/9/17.
//  Copyright © 2017 Jakub Buczek. All rights reserved.
//

import UIKit

class CurrencyUITableViewCell: UITableViewCell {

    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var detail: UILabel!
    
    var currency: Currency?
    
    func setCurrencyCellWith(currency: Currency) {
        DispatchQueue.main.async {
            self.currency = currency
            self.textLabel?.text = currency.base
            self.detailTextLabel?.text = "Details"
            //self.label.text = currency.base
            //self.detail.text = "Details"
        }
    }
    
    func getCurrencyFromCell() -> Currency{
        return self.currency!
    }
}
