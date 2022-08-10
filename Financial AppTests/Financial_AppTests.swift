//
//  Financial_AppTests.swift
//  Financial AppTests
//
//  Created by Maksim  on 10.08.2022.
//

import XCTest
@testable import Financial_App

class Financial_AppTests: XCTestCase {
    
    var sut: Calculator!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = Calculator()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func testInvestment_whenResultUsed_expectResult() {
        
        let initialInvestmentAmount: Double = 500
        let monthlyDollarCostAveragingAmount: Double = 300
        let initialDateInvestmentIndex = 4
        
        let investAmount =  sut.getInvestmentAmount(initialInvestmentAmount: initialInvestmentAmount,
                                monthlyDollarCostAveragingAmount: monthlyDollarCostAveragingAmount,
                                initialDateInvestmentIndex: initialDateInvestmentIndex)
        
        XCTAssertEqual(investAmount, 1700)
    }
    
    func testInvestmentAmount_whenDCAIsNotUsed_expectResult() {
        let initialInvestmentAmount: Double = 500
        let monthlyDollarCostAveragingAmount: Double = 0
        let initialDateInvestmentIndex = 4
        
        let investAmount =  sut.getInvestmentAmount(initialInvestmentAmount: initialInvestmentAmount,
                                monthlyDollarCostAveragingAmount: monthlyDollarCostAveragingAmount,
                                initialDateInvestmentIndex: initialDateInvestmentIndex)
        
        XCTAssertEqual(investAmount, 500)
        
        
    }
    
    func testResult_givenWinningAssetAndDCAIsUsed_expectPositiveGains() {
        let initialInvestmentAmount: Double = 5000
        let monthlyDollarCostAveragingAmount: Double = 1500
        let initialDateInvestmentIndex: Int = 5
        let asset = buildWinningAsset()
        
        let result = sut.calculate(asset: asset,
                                   initialInvestmentAmount: initialInvestmentAmount,
                                   monthlyDollarCostAveragingAmount: monthlyDollarCostAveragingAmount,
                                   initialDateInvestmentIndex: initialDateInvestmentIndex)
        
        XCTAssertEqual(result.investmentAmount, 12500, "investment amount is incorrect")
        XCTAssertTrue(result.isProfitable)
        
        XCTAssertEqual(result.currentValue, 17342.224)
    }
    
    private func buildWinningAsset() -> Asset {
        let searchResult = buildSearchResult()
        let buildMetaResult = buildMetaResult()
        let timeSeries: [String: OHLC] = [
            "2022-01-25" : OHLC(open: "100", close: "0", adjustedClose: "110"),
            "2022-02-25" : OHLC(open: "110", close: "0", adjustedClose: "120"),
            "2022-03-25" : OHLC(open: "120", close: "0", adjustedClose: "130"),
            "2022-04-25" : OHLC(open: "130", close: "0", adjustedClose: "140"),
            "2022-05-25" : OHLC(open: "140", close: "0", adjustedClose: "150"),
            "2022-06-25" : OHLC(open: "150", close: "0", adjustedClose: "160")
        ]
        let timeSeriesMonthlyAdjusted = TimeSeriesMonthlyAdjusted(meta: buildMetaResult, timeSeries: timeSeries)
        
        return Asset(searchResult: searchResult, timeSeriesMonthlyAdjusted: timeSeriesMonthlyAdjusted)
    }
    
    
    private func buildSearchResult() -> SearchResult {
        return SearchResult(symbol: "XYZ", name: "XYZ Company", type: "ETF", currency: "USD")
    }
    
    private func buildMetaResult() -> Meta {
        return Meta(symbol: "XYZ")
    }
    
    
    func testResult_givenWinningAssetAndDCAIsNotUsed_expectPositiveGains() {
        
    }
    
    func testResult_givenLosingAssetAndDCAIsUsed_expectNegativeGains() {
        
    }
    
    func testResult_givenLosingAssetAndDCAIsNotUsed_expectNegativeGains() {
        
    }
    
}
