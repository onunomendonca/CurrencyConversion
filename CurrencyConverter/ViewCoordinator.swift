//
//  MainView.swift
//  CurrencyConverter
//
//  Created by Nuno Mendonça on 02/09/2024.
//

import SwiftUI

struct ViewCoordinator: View {

    @State private var isActive = false
    @StateObject private var ratesViewModel = RatesViewModel(frankfurterService: FrankfurterService())

    var body: some View {

        if isActive == false {
            
            SplashScreen(isActive: $isActive)

        } else {

            TabView {
                CurrencyRatesView(viewModel: ratesViewModel).tabItem {

                    Image(systemName: "globe.europe.africa.fill")
                    Text("Rates")
                }

                CurrencyConversionView(viewModel: ratesViewModel).tabItem {

                    Image(systemName: "coloncurrencysign.circle.fill")
                    Text("Converter")
                }
            }
        }
    }
}

#Preview {
    ViewCoordinator()
}
