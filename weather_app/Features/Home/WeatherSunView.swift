//
//  WeatherMoonView.swift
//  weather_app
//
//  Created by MARQUES Thomas on 06/11/2025.
//

import SwiftUI
import DesignSystem

struct WeatherSunView: View {
    var day: ForecastDay
    
    var body: some View {
        HStack(spacing: 20) {
            Card(content: {
                HStack {
                    Image(Images.sunrise)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipped()
                    Text("\(day.astro.sunrise)")
                        .frame(maxWidth: .infinity)
                }
            })
            
            Card(content: {
                HStack {
                    Image(Images.sunset)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipped()
                    Text("\(day.astro.sunset)")
                        .frame(maxWidth: .infinity)
                }
            })
        }
    }
}
