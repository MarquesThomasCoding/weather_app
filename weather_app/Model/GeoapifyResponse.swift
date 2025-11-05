//
//  CityResponse.swift
//  weather_app
//
//  Created by MARQUES Thomas on 05/11/2025.
//

import SwiftUI

struct GeoapifyResponse: Codable {
    let type: String
    let features: [Feature]
    let query: Query?
}

struct Feature: Codable, Identifiable {
    var id: String { properties.place_id }
    let type: String
    let properties: Properties
    let geometry: Geometry
}

struct Properties: Codable {
    let place_id: String
    let country: String?
    let city: String?
    let state: String?
    let lon: Double?
    let lat: Double?
    let formatted: String?
}

struct Geometry: Codable {
    let type: String
    let coordinates: [Double]
}

struct Query: Codable {
    let text: String
}
