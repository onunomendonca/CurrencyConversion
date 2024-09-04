//
//  HomePageViewModel.swift
//  CurrencyConverter
//
//  Created by Nuno Mendonça on 02/09/2024.
//

import Foundation

class RatesViewModel: ObservableObject {

    private let frankfurterService: FrankfurterServiceProtocol
    private var loadTask: Task<Void, Never>?

    @Published var latestCurrencies: [Rate] = []
    @Published var baseCurrency: String = ""
    @Published var conversionHistory: [Conversion] = []

    init(frankfurterService: FrankfurterServiceProtocol) {

        self.frankfurterService = frankfurterService
    }

    func availableCurrencies() -> [String] {

        let uniqueCurrencies = latestCurrencies.map { rate in
            rate.currency
        }

        return Array(uniqueCurrencies).sorted()
    }

    func calculateConversion(amount: Decimal, baseCurrency: String, destinationCurrency: String) -> Conversion? {

        guard let baseRate = latestCurrencies.first(where: { $0.currency == baseCurrency })?.amount,
              let destinationRate = latestCurrencies.first(where: { $0.currency == destinationCurrency })?.amount else {

            return nil
        }

        let convertedAmount: Decimal = amount * (destinationRate / baseRate)

        let conversion = Conversion(baseCurrency: baseCurrency, amount: amount, destinationCurrency: destinationCurrency, conversion: convertedAmount)

        self.conversionHistory.append(conversion)

        return conversion
    }

    func loadLatestCurrencyRates() {

        guard latestCurrencies.isEmpty else { return }

        Task {
            do {

                let latestCurrencyRates = try await self.frankfurterService.getLatest()

                DispatchQueue.main.async {

                    var rates = latestCurrencyRates.rates
                    rates.append(Rate(currency: latestCurrencyRates.base, amount: 1))
                    self.latestCurrencies = rates.sorted()
                    self.baseCurrency = latestCurrencyRates.base
                }
            }
        }
    }
}
