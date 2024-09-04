//
//  Rate.swift
//  CurrencyConverter
//
//  Created by Nuno Mendonça on 02/09/2024.
//

import Foundation

struct Rate: Codable, Hashable, Comparable {

    let currency: String
    let amount: Decimal

    static func < (lhs: Rate, rhs: Rate) -> Bool {
        lhs.currency < rhs.currency
    }
}
