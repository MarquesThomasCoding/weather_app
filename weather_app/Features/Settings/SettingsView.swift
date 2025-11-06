//
//  SettingsView.swift
//  weather_app
//
//  Created by MARQUES Thomas on 05/11/2025.
//

import SwiftUI
import DesignSystem

struct SettingsView: View {
    @State var weatherViewModel = WeatherViewModel()
    @AppStorage("isCelsius") private var isCelsius: Bool = true
    
    init() {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        ZStack {
            Image(.backgroundLeverDeSoleil)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .ignoresSafeArea()
            
            Form {
                Card(content: {
                    Section(header: Text("settings.units")) {
                        Toggle(isOn: $isCelsius) {
                            Text("settings.usecelsius")
                        }
                    }
                    .foregroundStyle(.white)
                })
                .listRowBackground(Color.clear)
            }
            .scrollContentBackground(.hidden)
        }
    }
}

#Preview {
    SettingsView()
}
