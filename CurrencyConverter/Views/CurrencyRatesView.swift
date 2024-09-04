//
//  CurrencyRatesView.swift
//  CurrencyConverter
//
//  Created by Nuno Mendonça on 02/09/2024.
//

import SwiftUI

struct CurrencyRatesView: View {

    @State private var searchText = ""

    @StateObject var viewModel: RatesViewModel

    var filteredCurrencies: [Rate] {
            if searchText.isEmpty {
                return viewModel.latestCurrencies
            } else {
                return viewModel.latestCurrencies.filter { $0.currency.localizedCaseInsensitiveContains(searchText) }
            }
        }

    var body: some View {

        NavigationStack {

            List {
                Section(header: Text("Selected Currency")) {

                    HStack {

                        Text("EUR")
                        Spacer()
                        Text("1,00")
                    }
                }

                Section(header: Text("Currency Rates")) {

                    ForEach(self.filteredCurrencies, id: \.self) { rate in

                        HStack {

                            Text(rate.currency)
                            Spacer()
                            Text("\(rate.amount)")
                        }
                    }
                }
            }
            .headerProminence(.increased)
            .navigationTitle("Currency Rates")
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        }
        .onAppear { self.viewModel.loadLatestCurrencyRates() }
    }
}

#Preview {
    CurrencyRatesView(viewModel: .init(frankfurterService: FrankfurterService()))
}
