//
//  WeatherModel.swift
//  cours_ios
//
//  Created by MARQUES Thomas on 04/11/2025.
//

import SwiftUI

struct WeatherResponse: Codable {
    let location: Location
    let current: CurrentWeather
    let forecast: ForecastContainer
}

struct Location: Codable {
    let name: String
    let region: String
    let country: String
    let lat: Double
    let lon: Double
    let tz_id: String
    let localtime: String
}

struct CurrentWeather: Codable {
    let last_updated: String
    let temp_c: Double
    let temp_f: Double
    let is_day: Int
    let condition: Condition
    let wind_kph: Double
    let wind_dir: String
    let humidity: Double
}

struct Condition: Codable {
    let text: String
    let icon: String
    let code: Int
}

struct ForecastContainer: Codable {
    let forecastday: [ForecastDay]
}

struct ForecastDay: Codable, Identifiable {
    var id: String { date }
    let date: String
    let date_epoch: Double
    let day: DayWeather
    let astro: Astro
    let hour: [HourWeather]
}

struct DayWeather: Codable {
    let maxtemp_c: Double
    let maxtemp_f: Double
    let mintemp_c: Double
    let mintemp_f: Double
    let avgtemp_c: Double
    let avgtemp_f: Double
    let condition: Condition
}

struct Astro: Codable {
    let sunrise: String
    let sunset: String
    let moonrise: String
    let moonset: String
    let moon_phase: String
}

struct HourWeather: Codable, Identifiable {
    var id: Int { time_epoch }
    let time_epoch: Int
    let time: String
    let temp_c: Double
    let temp_f: Double
    let is_day: Int
    let condition: Condition
    let chance_of_rain: Double
}
