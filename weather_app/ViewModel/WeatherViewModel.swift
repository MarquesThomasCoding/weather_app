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
    
    var backgroundImage: ImageResource {
        guard let astro = weather?.forecast.forecastday.first?.astro else {
            return getBackgroundImageByHour()
        }
        
        let tzIdentifier = weather?.location.tz_id ?? "Europe/Paris"
        let localDate = getDate(for: tzIdentifier)
        
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: localDate)
        let minute = calendar.component(.minute, from: localDate)
        let currentMinutes = hour * 60 + minute
        
        if let sunriseMinutes = parseTimeToMinutes(astro.sunrise),
           abs(currentMinutes - sunriseMinutes) <= 30 {
            return Images.backgroundLeverDeSoleil
        }
        
        if let sunsetMinutes = parseTimeToMinutes(astro.sunset),
           abs(currentMinutes - sunsetMinutes) <= 30 {
            return Images.backgroundLeverDeSoleil
        }
        
        return getBackgroundImageByHour(date: localDate)
    }
    
    private func getDate(for timeZoneID: String) -> Date {
        guard let tz = TimeZone(identifier: timeZoneID) else { return Date() }
        let secondsFromGMT = tz.secondsFromGMT(for: Date())
        return Date(timeIntervalSinceNow: TimeInterval(secondsFromGMT - TimeZone.current.secondsFromGMT()))
    }
    
    private func getBackgroundImageByHour(date: Date = Date()) -> ImageResource {
        let hour = Calendar.current.component(.hour, from: date)
        
        switch hour {
        case 0...3:
            return Images.backgroundMidnight
        case 4...6:
            return Images.backgroundAube
        case 7...17:
            return Images.backgroundDay
        case 18...20:
            return Images.backgroundCrepuscule
        case 21...23:
            return Images.backgroundNight
        default:
            return Images.backgroundDay
        }
    }
    
    private func parseTimeToMinutes(_ timeString: String) -> Int? {
        let components = timeString.components(separatedBy: " ")
        guard components.count == 2 else { return nil }
        
        let timeParts = components[0].components(separatedBy: ":")
        guard timeParts.count == 2,
              var hour = Int(timeParts[0]),
              let minute = Int(timeParts[1]) else { return nil }
        
        let isPM = components[1].uppercased() == "PM"
        if isPM && hour != 12 {
            hour += 12
        } else if !isPM && hour == 12 {
            hour = 0
        }
        
        return hour * 60 + minute
    }
    
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

