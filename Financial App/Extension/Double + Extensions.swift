//
//  Double + Extensions.swift
//  Financial App
//
//  Created by Maksim  on 09.08.2022.
//

import Foundation

extension Double {
    
    var stringValue: String {
        return String(describing: self)
    }
    
    var twoDecimalPlaceString: String {
        return String(format: "%.2f", self)
    }
    
    var currencyFormat: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: self as NSNumber) ?? twoDecimalPlaceString
    }
    
    var percentageFormat: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        return formatter.string(from: self as NSNumber) ?? twoDecimalPlaceString
    }
    
    func toCurrencyFormat(hasDollarSymbol: Bool = true, hasDecimalPlaces: Bool = true) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        if !hasDollarSymbol {
            formatter.currencySymbol = ""
        }
        
        if !hasDecimalPlaces {
            formatter.maximumFractionDigits = 0
        }
        
        
        return formatter.string(from: self as NSNumber) ?? twoDecimalPlaceString
    }

}
