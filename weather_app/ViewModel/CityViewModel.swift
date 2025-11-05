//
//  CityViewModel.swift
//  weather_app
//
//  Created by MARQUES Thomas on 05/11/2025.
//

import SwiftUI

@Observable
class CityViewModel {
    var cities: [Feature] = []
    var isLoading = false
    var errorMessage: String?

    func fetchCities(for text: String) async {
        guard (text.count >= 3) else {
            cities = []
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        let apiKey = "171dc255113e4b84b90027bc1935c7d3"
        guard let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://api.geoapify.com/v1/geocode/autocomplete?text=\(encodedText)&apiKey=\(apiKey)") else {
            errorMessage = "URL invalide"
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(GeoapifyResponse.self, from: data)
            self.cities = decoded.features
        } catch {
            self.errorMessage = "Erreur de décodage : \(error.localizedDescription)"
            self.cities = []
        }
    }
}
