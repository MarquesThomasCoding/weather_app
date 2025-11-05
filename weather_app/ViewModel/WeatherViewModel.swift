//
//  WeatherViewModel.swift
//  weather_app
//
//  Created by MARQUES Thomas on 05/11/2025.
//

import SwiftUI
import DesignSystem

@Observable
class WeatherViewModel {
    var weather: WeatherResponse?
    var isLoading = false
    var errorMessage: String?
    
    func fetchWeather(for city: String = "Nanterre", days: Int = 3) async {
        isLoading = true
        defer { isLoading = false }
        
        let apiKey = "b01876319e9d4a949d0154404242001"
        guard let url = URL(string: "https://api.weatherapi.com/v1/forecast.json?key=\(apiKey)&q=\(city)&days=\(days)&aqi=no&alerts=no") else {
            errorMessage = "URL invalide"
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(WeatherResponse.self, from: data)
            self.weather = decoded
        } catch {
            self.errorMessage = "Erreur de décodage : \(error.localizedDescription)"
        }
    }
    
    func iconName(for conditionText: String) -> String {
        let mapping: [String: String] = [
            "Sunny": "sun",
            "Partly Cloudy": "partlyCloudy",
            "Cloudy": "cloud",
            "Rain": "rain",
        ]
        return mapping[conditionText] ?? "rain"
    }
    
    func moonPhaseImage(from apiPhase: String) -> ImageResource {
        switch apiPhase {
        case "New Moon": return Images.newMoon
        case "Waxing Crescent": return Images.waxingCrescent
        case "First Quarter": return Images.firstQuarter
        case "Waxing Gibbous": return Images.waxingGibbous
        case "Full Moon": return Images.fullMoon
        case "Waning Gibbous": return Images.waningGibbous
        default: return Images.fullMoon
        }
    }
}
