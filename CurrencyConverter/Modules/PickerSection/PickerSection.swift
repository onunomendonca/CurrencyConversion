//
//  PickerSection.swift
//  CurrencyConverter
//
//  Created by Nuno Mendonça on 03/09/2024.
//

import SwiftUI

struct PickerSection: View {

    let title: String
    @Binding var selection: String
    let options: [String]

    var body: some View {

        HStack {

            Text(title)
            Spacer()
            Picker("", selection: $selection) {
                ForEach(options, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(MenuPickerStyle())
        }
        .padding(.vertical)
    }
}
#Preview {
    PickerSection(title: "Choose Base Currency", selection: .constant("EUR"), options: ["EUR, AUD, USD"])
}
