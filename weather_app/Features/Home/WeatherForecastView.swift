//
//  WeatherForecastDays.swift
//  weather_app
//
//  Created by MARQUES Thomas on 06/11/2025.
//

import SwiftUI
import DesignSystem

struct WeatherForecastDays: View {
    var forecastDays: [ForecastDay]
    @Binding var isCelsius: Bool
    
    var body: some View {
        ForEach(forecastDays) { day in
            let dayTemp = isCelsius ? day.day.maxtemp_c : day.day.maxtemp_f
            let nightTemp = isCelsius ? day.day.mintemp_c : day.day.mintemp_f
            WeatherDayForecastCard(
                day: Date(timeIntervalSince1970: day.date_epoch).dayOfWeek(),
                icon: Images.fromConditionIcon(day.day.condition.text),
                dayTemperature: "\(Int(dayTemp))°\(isCelsius ? "C" : "F")",
                nightTemperature: "\(Int(nightTemp))°\(isCelsius ? "C" : "F")"
            )
        }
    }
}
