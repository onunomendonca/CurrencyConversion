//
//  Conversion.swift
//  CurrencyConverter
//
//  Created by Nuno Mendonça on 03/09/2024.
//

import Foundation

struct Conversion: Hashable, Identifiable {

    let id = UUID()

    let baseCurrency: String
    let amount: Decimal
    let destinationCurrency: String
    let conversion: Decimal
}
