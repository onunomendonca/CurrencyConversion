//
//  FrankfurterServiceMock.swift
//  CurrencyConverter
//
//  Created by Nuno Mendonça on 03/09/2024.
//

import Foundation
@testable import CurrencyConverter

class MockFrankfurterService: FrankfurterServiceProtocol {

    var currencyRatesResult: Result<CurrencyRates, Error>?

    func getLatest() async throws -> CurrencyRates {

        switch currencyRatesResult {

        case .success(let currencyRates):

            return currencyRates

        case .failure(let error):

            throw error

        case .none:

            throw FrankfurterServiceError.badResponse
        }
    }
}
