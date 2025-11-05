//
//  SettingsView.swift
//  weather_app
//
//  Created by MARQUES Thomas on 05/11/2025.
//

import SwiftUI
import DesignSystem

struct SettingsView: View {
    @AppStorage("isCelsius") private var isCelsius: Bool = true
    @AppStorage("selectedLanguage") private var selectedLanguage: String = "lang.french"
    
    let languages = ["lang.french", "lang.english"]
    
    init() {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        ZStack {
            gradientDarkBlueToSkyBlue
                .ignoresSafeArea()
            
            Form {
                Card(content: {
                    Section(header: Text("settings.units")) {
                        Toggle(isOn: $isCelsius) {
                            Text("settings.usecelsius")
                        }
                    }
                })
                .listRowBackground(Color.clear)
                
                Card(content: {
                    Section(header: Text("settings.lang")) {
                        Picker("settings.applang", selection: $selectedLanguage) {
                            ForEach(languages, id: \.self) { lang in
                                Text(lang)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                })
                .listRowBackground(Color.clear)
            }
            .scrollContentBackground(.hidden)
        }
        .foregroundStyle(.white)
    }
}

#Preview {
    SettingsView()
}
