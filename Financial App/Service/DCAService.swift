//
//  DCAService.swift
//  Financial App
//
//  Created by Maksim  on 09.08.2022.
//

import Foundation

struct DCAService {
    
    func calculate(asset: Asset,
                   initialInvestmentAmount: Double,
                   monthlyDollarCostAveragingAmount: Double,
                   initialDateInvestmentIndex: Int) -> DCAResult {
        
        let investmentAmount = getInvestmentAmount(initialInvestmentAmount: initialInvestmentAmount,
                                                   monthlyDollarCostAveragingAmount: monthlyDollarCostAveragingAmount,
                                                   initialDateInvestmentIndex: initialDateInvestmentIndex)
        
        let latestSharePrice = getLatestSharePrice(asset: asset)
        
        let numberOfShares = getNumberOfShares(asset: asset,
                                               initialInvestmentAmount: initialInvestmentAmount,
                                               monthlyDollarCostAveragingAmount: monthlyDollarCostAveragingAmount,
                                               initialDateInvestmentIndex: initialDateInvestmentIndex)
        
        let currentValue = getCurrentValue(numberOfShares: numberOfShares, latestSharePrice: latestSharePrice)
        
        let isProfit = currentValue > investmentAmount
        let gain = currentValue - investmentAmount
        
        return .init(currentValue: currentValue, investmentAmount: investmentAmount, gain: gain, yield: 0, annualReturn: 0, isProfitable: isProfit)
    }
    
    private func getInvestmentAmount(initialInvestmentAmount: Double,
                                     monthlyDollarCostAveragingAmount: Double,
                                     initialDateInvestmentIndex: Int) -> Double {
        
        var totalAmount = Double()
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
    
    func getNumberOfShares(asset: Asset, initialInvestmentAmount: Double,
                   monthlyDollarCostAveragingAmount: Double, initialDateInvestmentIndex: Int) -> Double {
        
       var totalShares = Double()
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

struct DCAResult {
    
    let currentValue: Double
    let investmentAmount: Double
    let gain: Double
    let yield: Double
    let annualReturn: Double
    let isProfitable: Bool
    
}
