//
//  CurrencyRates.swift
//  CurrencyConverter
//
//  Created by Nuno Mendonça on 02/09/2024.
//

import Foundation

struct CurrencyRates: Codable {

    let amount: Double?
    let base: String
    let date: String?
    let rates: [Rate]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        amount = try container.decode(Double.self, forKey: .amount)
        base = try container.decode(String.self, forKey: .base)
        date = try container.decode(String.self, forKey: .date)

        let ratesDictionary = try container.decode([String: Decimal].self, forKey: .rates)
        rates = ratesDictionary.map { Rate(currency: $0.key, amount: $0.value) }
    }

    init(amount: Double? = nil, base: String, date: String? = nil, rates: [Rate]) {

        self.amount = amount
        self.base = base
        self.date = date
        self.rates = rates
    }
}
