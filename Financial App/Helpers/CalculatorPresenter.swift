//
//  CalculatorPresenter.swift
//  Financial App
//
//  Created by Maksim  on 05.09.2022.
//

import Foundation
import UIKit

class CalculatorPresenter {
    
    func getPresentation(result: Result) -> CalculatorPresentation {
        
        let isProfitable = result.isProfitable == true
        let gainSymbol = isProfitable ? "+" : ""
        
        return .init(
            currentValueLabelBackgroundColor: isProfitable ? .systemGreen : .systemRed,
            currentValue: result.currentValue.currencyFormat,
            investmentAmount: result.investmentAmount.toCurrencyFormat(hasDecimalPlaces: false),
            gain: result.gain.toCurrencyFormat(hasDollarSymbol: true, hasDecimalPlaces: false).prefix(withText: gainSymbol),
            yield: result.yield.percentageFormat.prefix(withText: gainSymbol).addBrackets(),
            yieldLabelTextColor: isProfitable ? .systemGreen : .systemRed,
            annualReturn: result.annualReturn.percentageFormat,
            annualReturnLabelTextColor: isProfitable ? .systemGreen : .systemRed)
    }
    
}

struct CalculatorPresentation {
    let currentValueLabelBackgroundColor: UIColor
    let currentValue: String
    let investmentAmount: String
    let gain: String
    let yield: String
    let yieldLabelTextColor: UIColor
    let annualReturn: String
    let annualReturnLabelTextColor: UIColor
}
