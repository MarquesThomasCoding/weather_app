//
//  WeatherMoonView.swift
//  weather_app
//
//  Created by MARQUES Thomas on 06/11/2025.
//

import SwiftUI
import DesignSystem

struct WeatherMoonView: View {
    var weatherViewModel: WeatherViewModel
    var day: ForecastDay
    
    var body: some View {
        Card(content: {
            HStack {
                VStack {
                    Image(weatherViewModel.moonPhaseImage(from: day.astro.moon_phase))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 96, height: 96)
                    let localizedMoonPhase = NSLocalizedString(day.astro.moon_phase, comment: "")
                    Text("\(localizedMoonPhase)")
                        .foregroundStyle(.secondary)
                        .font(.footnote)
                }
                Spacer()
                VStack {
                    VStack(alignment: .leading) {
                        Text("data.moonrise")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                        Text("\(day.astro.moonrise)")
                    }
                    VStack(alignment: .leading) {
                        Text("data.moonrise")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                        Text("\(day.astro.moonset)")
                    }
                }
                Spacer()
            }
        })
    }
}
