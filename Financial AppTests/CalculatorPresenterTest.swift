//
//  CalculatorPresenterTest.swift
//  Financial AppTests
//
//  Created by Maksim  on 05.09.2022.
//

import XCTest
@testable import Financial_App

class CalculatorPresenterTest: XCTestCase {
    
    var sut: CalculatorPresenter!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = CalculatorPresenter()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }

    func testAnnualReturnLabelTextColor_givenResultIsProfitable_expectSystemGreen()  {
        
        let result = Result(
            currentValue: 0,
            investmentAmount: 0,
            gain: 0,
            yield: 0,
            annualReturn: 0,
            isProfitable: true)
        
        let presentation = sut.getPresentation(result: result)

        XCTAssertEqual(presentation.annualReturnLabelTextColor, UIColor.systemGreen)
    }
    
    func testYieldLabelTextColor_givenResultIsProfitable_expectSystemGreen()  {
        let result = Result(
            currentValue: 0,
            investmentAmount: 0,
            gain: 0,
            yield: 0,
            annualReturn: 0,
            isProfitable: true)
       
        let presentation = sut.getPresentation(result: result)

        XCTAssertEqual(presentation.yieldLabelTextColor, UIColor.systemGreen)
    }
    
    func testAnnualReturnLabelTextColor_givenResultIsNotProfitable_expectSystemRed()  {
        
        let result = Result(
            currentValue: 0,
            investmentAmount: 0,
            gain: 0,
            yield: 0,
            annualReturn: 0,
            isProfitable: false)
        
        let presentation = sut.getPresentation(result: result)

        XCTAssertEqual(presentation.annualReturnLabelTextColor, UIColor.systemRed)
    }
    
    func testYieldLabelTextColor_givenResultIsNotProfitable_expectSystemRed()  {
        let result = Result(
            currentValue: 0,
            investmentAmount: 0,
            gain: 0,
            yield: 0,
            annualReturn: 0,
            isProfitable: false)
       
        let presentation = sut.getPresentation(result: result)

        XCTAssertEqual(presentation.yieldLabelTextColor, UIColor.systemRed)
    }

    func testYieldLabel_expectBrackets() {
        let openBracket: Character = "("
        let closeBracket: Character = ")"
        
        let result = Result(
            currentValue: 0,
            investmentAmount: 0,
            gain: 0,
            yield: 0.25,
            annualReturn: 0,
            isProfitable: false
        )
        
        let presentation = sut.getPresentation(result: result)
        
        XCTAssertEqual(presentation.yield.first, openBracket)
        XCTAssertEqual(presentation.yield.last, closeBracket)
        
    }
}
