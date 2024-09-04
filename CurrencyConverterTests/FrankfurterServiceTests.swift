//
//  FrankfurterServiceTests.swift
//  CurrencyConverter
//
//  Created by Nuno Mendonça on 04/09/2024.
//

import XCTest
@testable import CurrencyConverter

final class FrankfurterServiceTests: XCTestCase {

    var service: FrankfurterService!
    var mockURLSession: MockURLSession!

    override func setUp() {

        super.setUp()
        self.mockURLSession = MockURLSession()
        self.service = FrankfurterService(session: mockURLSession)
    }

    override func tearDown() {

        self.service = nil
        self.mockURLSession = nil
        super.tearDown()
    }

    func testGetLatestSuccess() async throws {

        self.mockURLSession.nextData = """
            {
                "amount": 1.0,
                "base": "EUR",
                "date": "2024-09-04",
                "rates": {
                    "USD": 1.234,
                    "GBP": 1.0256
                }
            }
            """.data(using: .utf8)
        self.mockURLSession.nextResponse = HTTPURLResponse(url: URL(string: "https://api.frankfurter.app/latest")!,
                                                           statusCode: 200,
                                                           httpVersion: nil,
                                                           headerFields: nil)

        let currencyRates = try await self.service.getLatest()

        let sortedRates = currencyRates.rates.sorted { $0.currency < $1.currency }

        XCTAssertEqual(currencyRates.base, "EUR")
        XCTAssertEqual(sortedRates.count, 2)
        XCTAssertEqual(sortedRates[0].currency, "GBP")
        XCTAssertEqual(sortedRates[0].amount, 1.0256)
        XCTAssertEqual(sortedRates[1].currency, "USD")
        XCTAssertEqual(sortedRates[1].amount, 1.234)
    }

    func testGetLatestBadRequest() async {
        // Given
        self.mockURLSession.nextResponse = HTTPURLResponse(url: URL(string: "https://api.frankfurter.app/latest")!,
                                                           statusCode: 400,
                                                           httpVersion: nil,
                                                           headerFields: nil)

        do {

            _ = try await service.getLatest()
            XCTFail("Expected error to be thrown")

        } catch {

            XCTAssertEqual(error as? FrankfurterServiceError, .badRequest)
        }
    }

    func testGetLatestBadResponse() async {

        self.mockURLSession.nextData = "InVaLiD json".data(using: .utf8)
        self.mockURLSession.nextResponse = HTTPURLResponse(url: URL(string: "https://api.frankfurter.app/latest")!,
                                                           statusCode: 200,
                                                           httpVersion: nil,
                                                           headerFields: nil)

        do {

            _ = try await service.getLatest()
            XCTFail("Expected error to be thrown")

        } catch {

            XCTAssertEqual(error as? FrankfurterServiceError, .badResponse)
        }
    }
}

// Mocking URLSession
class MockURLSession: URLSessionProtocol {

    var nextData: Data?
    var nextResponse: URLResponse?
    var nextError: Error?

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {

        if let error = nextError {
            throw error
        }

        let response = nextResponse ?? HTTPURLResponse(url: request.url!,
                                                       statusCode: 200,
                                                       httpVersion: nil,
                                                       headerFields: nil)!
        let data = nextData ?? Data()
        return (data, response)
    }
}
