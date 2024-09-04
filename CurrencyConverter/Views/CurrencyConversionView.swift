//
//  CurrencyConversionView.swift
//  CurrencyConverter
//
//  Created by Nuno Mendonça on 02/09/2024.
//

import SwiftUI

struct CurrencyConversionView: View {

    @State private var amountToConvert = ""
    @State private var baseCurrency = "EUR"
    @State private var destinationCurrency = "USD"
    @State private var conversion: Conversion?
    @State private var converterPressed = false

    @StateObject var viewModel: RatesViewModel

    var body: some View {

        NavigationStack {

            ScrollView {

                let currencies = self.viewModel.availableCurrencies()

                PickerSection(title: "Choose the Base Currency", 
                              selection: self.$baseCurrency,
                              options: currencies)

                TextField("Enter the amount to convert", text: $amountToConvert)
                    .multilineTextAlignment(.center)
                    .keyboardType(.decimalPad)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))

                PickerSection(title: "Choose the Destination Currency",
                              selection: self.$destinationCurrency,
                              options: currencies)

                Button {

                    self.converterPressed = true

                    if let amountDouble = Decimal(string: self.amountToConvert),
                       let conversion = viewModel.calculateConversion(amount: amountDouble,
                                                                      baseCurrency: self.baseCurrency,
                                                                      destinationCurrency: self.destinationCurrency) {

                        self.conversion = conversion
                        self.amountToConvert = ""


                    } else {

                        self.conversion = nil
                    }

                } label: {
                    Text("Convert")
                        .padding()
                }
                .font(.title)
                .foregroundStyle(.white)
                .background(Color.blue)
                .clipShape(.buttonBorder)

                if let conversion = self.conversion {

                    Text("The Rate is: \(conversion.conversion)")
                        .font(.title3)
                        .foregroundColor(.green)
                        .padding()

                    Text("Conversion History")
                        .font(.title)
                        .padding(.vertical)

                    ForEach(self.viewModel.conversionHistory) { conversion in

                        Text("\(conversion.amount) \(conversion.baseCurrency) is \(conversion.conversion) \(conversion.destinationCurrency)")
                    }
                } else {

                    if self.converterPressed {

                        Text("Please enter a valid amount.")
                            .font(.title3)
                            .foregroundStyle(.red)
                    }
                }
            }
            .padding()
            .navigationTitle("Currency Conversion")
            .background(Color(UIColor.systemGroupedBackground))
        }
    }
}

#Preview {
    CurrencyConversionView(viewModel: .init(frankfurterService: FrankfurterService()))
}
