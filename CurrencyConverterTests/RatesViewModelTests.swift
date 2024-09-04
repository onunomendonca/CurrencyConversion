//
//  RatesViewModelTests.swift
//  RatesViewModelTests
//
//  Created by Nuno Mendonça on 03/09/2024.
//

import XCTest
@testable import CurrencyConverter

class RatesViewModelTests: XCTestCase {

    var viewModel: RatesViewModel!
    var mockService: MockFrankfurterService!

    override func setUp() {

        super.setUp()
        self.mockService = MockFrankfurterService()
        self.viewModel = RatesViewModel(frankfurterService: self.mockService)
    }

    override func tearDown() {

        self.viewModel = nil
        self.mockService = nil
        super.tearDown()
    }

    func testAvailableCurrenciesAndSortThem() {

        self.viewModel.latestCurrencies = [
            Rate(currency: "REA", amount: 9.75),
            Rate(currency: "BRR", amount: 1.85)
        ]

        let availableCurrencies = self.viewModel.availableCurrencies()

        XCTAssertEqual(availableCurrencies, ["BRR", "REA"])
    }

    func testCalculateConversionBetweenTwoFictionalRates() {

        self.viewModel.latestCurrencies = [
            Rate(currency: "PRA", amount: 1.0),
            Rate(currency: "TIC", amount: 0.75)
        ]

        let conversion = self.viewModel.calculateConversion(amount: 100, 
                                                       baseCurrency: "PRA",
                                                       destinationCurrency: "TIC")

        XCTAssertEqual(conversion?.conversion, 75.0)
    }
}
