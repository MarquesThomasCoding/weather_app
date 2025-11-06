//
//  WeatherHoursView.swift
//  weather_app
//
//  Created by MARQUES Thomas on 06/11/2025.
//

import SwiftUI
import DesignSystem

struct WeatherHoursView: View {
    var forecastDays: [ForecastDay]
    @Binding var isCelsius: Bool
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                if let hours = forecastDays.first?.hour {
                    ForEach(hours) { hour in
                        let hourTemp = isCelsius ? hour.temp_c : hour.temp_f
                        let iconString = hour.condition.text
                        let iconResource = Images.fromConditionIcon(iconString)
                        WeatherHourCard(
                            hour: hour.time.components(separatedBy: " ").last ?? "",
                            icon: iconResource,
                            temperature: "\(Int(hourTemp))°\(isCelsius ? "C" : "F")",
                            chance_of_rain: hour.chance_of_rain
                        )
                    }
                }
            }
        }
    }
}
