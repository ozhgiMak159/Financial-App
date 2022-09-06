//
//  DCAServiceTests.swift
//  Financial AppTests
//
//  Created by Maksim  on 10.08.2022.
//

import XCTest
@testable import Financial_App

class DCAServiceTests: XCTestCase {
    
    var sut: Calculator!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = Calculator()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    // MARK: - UnitTesting
    func testInvestment_whenResultUsed_expectResult() {
        
        let initialInvestmentAmount: Double = 500
        let monthlyDollarCostAveragingAmount: Double = 300
        let initialDateInvestmentIndex = 4
        
        let investAmount =  sut.getInvestmentAmount(
            initialInvestmentAmount: initialInvestmentAmount,
            monthlyDollarCostAveragingAmount: monthlyDollarCostAveragingAmount,
            initialDateInvestmentIndex: initialDateInvestmentIndex
        )
        
        XCTAssertEqual(investAmount, 1700)
        
        // Расчет:
        /*
         Initial Amount: $500
         DCA: 4 x $300 = $1200
         total: $1200 + $500 = $1700
         */
    }
    
    func testInvestmentAmount_whenDCAIsNotUsed_expectResult() {
        // given
        let initialInvestmentAmount: Double = 500
        let monthlyDollarCostAveragingAmount: Double = 0
        let initialDateInvestmentIndex = 4
        
        // when
        let investAmount =  sut.getInvestmentAmount(
            initialInvestmentAmount: initialInvestmentAmount,
            monthlyDollarCostAveragingAmount: monthlyDollarCostAveragingAmount,
            initialDateInvestmentIndex: initialDateInvestmentIndex
        )
        
        // then
        XCTAssertEqual(investAmount, 500)
        
        // Расчет:
        /*
         Initial Amount: $500
         DCA: 4 x $0 = $0
         total: $0 + $500 = $500
         */
    }
    
    func testResult_givenWinningAssetAndDCAIsUsed_expectPositiveGains() {
        // given
        let initialInvestmentAmount: Double = 5000
        let monthlyDollarCostAveragingAmount: Double = 1500
        let initialDateInvestmentIndex: Int = 5
        let asset = buildWinningAsset()
        
        // when
        let result = sut.calculate(
            asset: asset,
            initialInvestmentAmount: initialInvestmentAmount,
            monthlyDollarCostAveragingAmount: monthlyDollarCostAveragingAmount,
            initialDateInvestmentIndex: initialDateInvestmentIndex
        )
        
        // then
        XCTAssertEqual(result.investmentAmount, 12500)
        XCTAssertTrue(result.isProfitable)
        
        XCTAssertEqual(result.currentValue, 17342.223, accuracy: 0.1)
        XCTAssertEqual(result.gain, 4842.224, accuracy: 0.1)
        XCTAssertEqual(result.yield, 0.3873, accuracy: 0.0001)
        
        // Расчет:
        /*
         XCTAssertEqual!
         
         Initial Investment: $5000
         DCA: 5 x $1500 = $7500
         total: $5000 + $7500 = $12500
         
         Январь: $5000 / 100 = 50 shares
         Февраль: $5000 / 110 = 50 shares
         Март: $5000 / 120 = 50 shares
         Апрель: $5000 / 130 = 50 shares
         Май: $5000 / 140 = 50 shares
         Июнь: $5000 / 150 = 50 shares
         Total shares = 108.3889 shares
         Total current value = 108.3889 x $160 = $17,342.224
         
         */
    }
    
    func testResult_givenWinningAssetAndDCAIsNotUsed_expectPositiveGains() {
        // given
        let initialInvestmentAmount: Double = 5000
        let monthlyDollarCostAveragingAmount: Double = 0
        let initialDateInvestmentIndex: Int = 3
        let asset = buildWinningAsset()
        
        // when
        let result = sut.calculate(
            asset: asset,
            initialInvestmentAmount: initialInvestmentAmount,
            monthlyDollarCostAveragingAmount: monthlyDollarCostAveragingAmount,
            initialDateInvestmentIndex: initialDateInvestmentIndex
        )
        
        // then
        XCTAssertEqual(result.investmentAmount, 5000)
        XCTAssertTrue(result.isProfitable)
        
        XCTAssertEqual(result.currentValue, 6666.666, accuracy: 0.1)
        XCTAssertEqual(result.gain, 1666.666, accuracy: 0.1)
        XCTAssertEqual(result.yield, 0.3333, accuracy: 0.0001)
        
        // Расчет:
        /*
         XCTAssertEqual!
         
         Initial Investment: $5000
         DCA: 3 x $0 = $0
         total: $5000 + $0 = $5000
         
         Март: $5000 / 120 = 41.6666 shares
         Апрель: $0 / 130 = 0 shares
         Май: $0 / 140 = 0 shares
         Июнь: $0 / 150 = 0 shares
         Total shares = 41.6666 shares
         Total current value = 41.6666 x $160 = $6666,666
         
         gain = (Total current value - initialInvestmentAmount)
         gain = 6666,666 - 5000 = 1666.666
         
         yield = gain / initialInvestmentAmount
         yield = 1666.666 / 5000 = 0.3333
         */
        
    }
    
    func testResult_givenLosingAssetAndDCAIsUsed_expectNegativeGains() {
        // given
        let initialInvestmentAmount: Double = 5000
        let monthlyDollarCostAveragingAmount: Double = 1500
        let initialDateInvestmentIndex: Int = 5
        let asset = buildLosingAsset()
        
        // when
        let result = sut.calculate(
            asset: asset,
            initialInvestmentAmount: initialInvestmentAmount,
            monthlyDollarCostAveragingAmount: monthlyDollarCostAveragingAmount,
            initialDateInvestmentIndex: initialDateInvestmentIndex
        )
        
        // then
        XCTAssertEqual(result.investmentAmount, 12500)
        XCTAssertFalse(result.isProfitable)
        
        XCTAssertEqual(result.currentValue, 9189.323, accuracy: 0.1)
        XCTAssertEqual(result.gain, -3310.677, accuracy: 0.1)
        XCTAssertEqual(result.yield, -0.2648, accuracy: 0.0001)
        
        // Расчет:
        /*
         XCTAssertEqual!
         
         Initial Investment: $5000
         DCA: 5 x $1500 = $7500
         total: $5000 + $7500 = $12500
         
         Январь: $5000 / 170 = 29.4117 shares
         Февраль: $1500 / 160 = 9.375 shares
         Март: $1500 / 150 = 10 shares
         Апрель: $1500 / 140 = 10.7142 shares
         Май: $1500 / 130 = 11.5384 shares
         Июнь: $1500 / 120 = 12.5 shares
         
         Total shares = 83.5393 shares
         Total current value = 83.5393 x $110(last month closing price) = $9189.323
         
         gain = (Total current value - initialInvestmentAmount)
         gain = 9189.323 - 12500 = -3310.677
         
         yield = gain / initialInvestmentAmount
         yield = -3310.677 / 12500 = -0.2648
         */
        
    }
    
    func testResult_givenLosingAssetAndDCAIsNotUsed_expectNegativeGains() {
        // given
        let initialInvestmentAmount: Double = 5000
        let monthlyDollarCostAveragingAmount: Double = 0
        let initialDateInvestmentIndex: Int = 3
        let asset = buildLosingAsset()
        
        // when
        let result = sut.calculate(
            asset: asset,
            initialInvestmentAmount: initialInvestmentAmount,
            monthlyDollarCostAveragingAmount: monthlyDollarCostAveragingAmount,
            initialDateInvestmentIndex: initialDateInvestmentIndex
        )
        
        // then
        XCTAssertEqual(result.investmentAmount, 5000)
        XCTAssertFalse(result.isProfitable)
        
        XCTAssertEqual(result.currentValue, 3666.6666, accuracy: 0.1)
        XCTAssertEqual(result.gain, -1333.333, accuracy: 0.1)
        XCTAssertEqual(result.yield, -0.26666, accuracy: 0.0001)
        
        // Расчет:
        /*
         XCTAssertEqual!
         
         Initial Investment: $5000
         DCA: 3 x $0 = $0
         total: $5000 + $0 = $5000
         
         Март: $5000 / 150 = 33.3333 shares
         Апрель: $0 / 140 = 0 shares
         Май: $0 / 130 = 0 shares
         Июнь: $0 / 120 = 0 shares
         
         Total shares = 33.3333 shares
         Total current value = 33.3333 x $110(last month closing price) = $3666.6666
         
         gain = (Total current value - initialInvestmentAmount)
         gain = 3666.6666 - 5000 = -1333.333
         
         yield = gain / initialInvestmentAmount
         yield = -1333.333 / 5000 = -0.26666
         */
    }
}

extension DCAServiceTests {
    private func buildWinningAsset() -> Asset {
        let searchResult = buildSearchResult()
        let buildMetaResult = buildMetaResult()
        let timeSeries: [String: OHLC] = [
            "2022-01-25" : OHLC(open: "100", close: "110", adjustedClose: "110"),
            "2022-02-25" : OHLC(open: "110", close: "120", adjustedClose: "120"),
            "2022-03-25" : OHLC(open: "120", close: "130", adjustedClose: "130"),
            "2022-04-25" : OHLC(open: "130", close: "140", adjustedClose: "140"),
            "2022-05-25" : OHLC(open: "140", close: "150", adjustedClose: "150"),
            "2022-06-25" : OHLC(open: "150", close: "160", adjustedClose: "160")
        ]
        
        let timeSeriesMonthlyAdjusted = TimeSeriesMonthlyAdjusted(meta: buildMetaResult, timeSeries: timeSeries)
        
        return Asset(searchResult: searchResult, timeSeriesMonthlyAdjusted: timeSeriesMonthlyAdjusted)
    }
    
    private func buildLosingAsset() -> Asset {
        let searchResult = buildSearchResult()
        let buildMetaResult = buildMetaResult()
        let timeSeries: [String: OHLC] = [
            "2022-01-25" : OHLC(open: "170", close: "160", adjustedClose: "160"),
            "2022-02-25" : OHLC(open: "160", close: "150", adjustedClose: "150"),
            "2022-03-25" : OHLC(open: "150", close: "140", adjustedClose: "140"),
            "2022-04-25" : OHLC(open: "140", close: "130", adjustedClose: "130"),
            "2022-05-25" : OHLC(open: "130", close: "120", adjustedClose: "120"),
            "2022-06-25" : OHLC(open: "120", close: "110", adjustedClose: "110")
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
}
