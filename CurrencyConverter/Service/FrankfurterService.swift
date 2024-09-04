//
//  FrankfurterService.swift
//  CurrencyConverter
//
//  Created by Nuno Mendonça on 02/09/2024.
//

import Foundation

protocol FrankfurterServiceProtocol {

    func getLatest() async throws -> CurrencyRates
}

enum FrankfurterServiceError: Error {

    case badURL
    case badRequest
    case badResponse
}

class FrankfurterService: FrankfurterServiceProtocol {

    private let session: URLSessionProtocol

    init(session: URLSessionProtocol = URLSession.shared) {

        self.session = session
    }

    func getLatest() async throws -> CurrencyRates {
            var components = self.frankfurterServiceURLComponents()
            components.path = "/latest"

            guard let url = components.url else {

                throw FrankfurterServiceError.badURL
            }

            let (data, response) = try await self.session.data(for: URLRequest(url: url))

            guard (response as? HTTPURLResponse)?.statusCode == 200 else {

                throw FrankfurterServiceError.badRequest
            }

            let currencyRates: CurrencyRates

            do {

                currencyRates = try JSONDecoder().decode(CurrencyRates.self, from: data)

            } catch {

                throw FrankfurterServiceError.badResponse
            }

            return currencyRates
        }
}

//MARK: FrankfurterService URL Components Builder
private extension FrankfurterService {

    private func frankfurterServiceURLComponents() -> URLComponents {

        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.frankfurter.app"

        return components
    }
}
