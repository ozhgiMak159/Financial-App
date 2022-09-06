//
//  Calculator.swift
//  Financial App
//
//  Created by Maksim  on 09.08.2022.
//

import Foundation

class Calculator {
    
    func calculate(asset: Asset, initialInvestmentAmount: Double, monthlyDollarCostAveragingAmount: Double, initialDateInvestmentIndex: Int) -> Result {
        
        let investmentAmount = getInvestmentAmount(initialInvestmentAmount: initialInvestmentAmount,monthlyDollarCostAveragingAmount: monthlyDollarCostAveragingAmount, initialDateInvestmentIndex: initialDateInvestmentIndex)
        
        let latestSharePrice = getLatestSharePrice(asset: asset)
        
        let numberOfShares = getNumberOfShares(asset: asset, initialInvestmentAmount: initialInvestmentAmount,monthlyDollarCostAveragingAmount: monthlyDollarCostAveragingAmount, initialDateInvestmentIndex: initialDateInvestmentIndex)
        
        let currentValue = getCurrentValue(numberOfShares: numberOfShares, latestSharePrice: latestSharePrice)
        
        let annualReturn = getAnnualReturn(currentValue: currentValue, investmentAmount: investmentAmount,
                            initialDateOfInvestmentIndex: initialDateInvestmentIndex)
        
        let isProfit = currentValue > investmentAmount
        let gain = currentValue - investmentAmount
        let yield = gain / investmentAmount
        
        
        return .init(currentValue: currentValue, investmentAmount: investmentAmount,
                     gain: gain, yield: yield, annualReturn: annualReturn,
                     isProfitable: isProfit)
    }
    
    private func getAnnualReturn(currentValue: Double, investmentAmount: Double, initialDateOfInvestmentIndex: Int) -> Double {
        let rate = currentValue / investmentAmount
        let yers = (initialDateOfInvestmentIndex.doubleValue + 1) / 12
        let result = pow(rate, (1 / yers)) - 1
        return result
    }
    
     func getInvestmentAmount(initialInvestmentAmount: Double, monthlyDollarCostAveragingAmount: Double, initialDateInvestmentIndex: Int) -> Double {
        var totalAmount = 0.0
        totalAmount += initialInvestmentAmount
        
        let dollarCostAveragingAmount = initialDateInvestmentIndex.doubleValue * monthlyDollarCostAveragingAmount
        totalAmount += dollarCostAveragingAmount
        
        return totalAmount
    }
    
    private func getCurrentValue(numberOfShares: Double, latestSharePrice: Double) -> Double {
        return numberOfShares * latestSharePrice
    }
    
    private func getLatestSharePrice(asset: Asset) -> Double {
        return asset.timeSeriesMonthlyAdjusted.getMonthInfos().first?.adjustedClose ?? 0
    }
    
    func getNumberOfShares(asset: Asset, initialInvestmentAmount: Double, monthlyDollarCostAveragingAmount: Double, initialDateInvestmentIndex: Int) -> Double {
        
        var totalShares = 0.0
        let initialInvestmentOpenPrice = asset.timeSeriesMonthlyAdjusted.getMonthInfos()[initialDateInvestmentIndex].adjustedOpen
        let initialInvestmentShares = initialInvestmentAmount / initialInvestmentOpenPrice
        totalShares += initialInvestmentShares
        asset.timeSeriesMonthlyAdjusted.getMonthInfos().prefix(initialDateInvestmentIndex).forEach { monthInfo in
            let dcaInvestmentShares = monthlyDollarCostAveragingAmount / monthInfo.adjustedOpen
            totalShares += dcaInvestmentShares 
        }
            return totalShares
    }

}

