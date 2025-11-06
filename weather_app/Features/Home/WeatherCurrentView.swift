//
//  WeatherCurrentView.swift
//  weather_app
//
//  Created by MARQUES Thomas on 06/11/2025.
//

import SwiftUI
import DesignSystem

struct WeatherCurrentView: View {
    var current: CurrentWeather
    @Binding var isCelsius: Bool
    @State var temp: Double = 0
    
    var body: some View {
        HStack {
            Card(content: {
                let localizedCurrentWeatherText = NSLocalizedString(current.condition.text, comment: "")
                
                Text("\(String(format: "%.1f", temp)) °\(isCelsius ? "C" : "F")")
                    .font(.largeTitle)
                Text(localizedCurrentWeatherText)
            })
            Spacer()
            Image(Images.fromConditionIcon(current.condition.text))
                .resizable()
                .frame(width: 128, height: 128)
            Spacer()
        }
    }
}
