//
//  WeatherHeader.swift
//  weather_app
//
//  Created by MARQUES Thomas on 06/11/2025.
//

import SwiftUI
import DesignSystem

struct WeatherHeader: View {
    var weatherViewModel: WeatherViewModel
    var selectedCity: String = "Nanterre"
    
    var body: some View {
        HStack {
            if let location = weatherViewModel.weather?.location {
                Text("\(location.name), \(location.region)")
                    .font(.title3)
                    .foregroundColor(.black.opacity(0.7))
            }
            Spacer()
            ButtonPrimary(label: "", icon: "arrow.2.circlepath") {
                Task {
                    await weatherViewModel.fetchWeather(for: "\(selectedCity)", days: 3)
                }
            }
        }
    }
}
