//
//  SplashScreen.swift
//  CurrencyConverter
//
//  Created by Nuno Mendonça on 03/09/2024.
//

import SwiftUI

struct SplashScreen: View {
    @State private var scale = 0.0
    @Binding var isActive: Bool

    var body: some View {

        ZStack {

            Color(UIColor.systemGroupedBackground)

            VStack {
                Image("currencyConverter")
                    .scaleEffect(scale)
                    .onAppear{
                        withAnimation(.easeIn(duration: 0.7)) {
                            self.scale = 0.5
                        }
                    }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    SplashScreen(isActive: .constant(false))
}
