//
//  WeatherMoreInfosView.swift
//  weather_app
//
//  Created by MARQUES Thomas on 06/11/2025.
//

import SwiftUI
import DesignSystem

struct WeatherMoreInfosView: View {
    var current: CurrentWeather
    
    var body: some View {
        HStack(spacing: 10) {
            Card(content: {
                HStack {
                    Image(Images.wind)
                        .resizable()
                        .frame(width: 32, height: 32)
                        .clipped()
                    Text("\(current.wind_kph, specifier: "%.0f")km/h")
                        .frame(maxWidth: .infinity)
                        .font(.footnote)
                }
                Text("data.windspeed")
                    .font(.custom("Poppins-Light", size: 10))
                    .foregroundStyle(.secondary)
            })
            
            Card(content: {
                HStack {
                    Image(Images.compass)
                        .resizable()
                        .frame(width: 32, height: 32)
                        .clipped()
                    Text("\(current.wind_dir)")
                        .frame(maxWidth: .infinity)
                        .font(.footnote)
                }
                Text("data.winddirection")
                    .font(.custom("Poppins-Light", size: 10))
                    .foregroundStyle(.secondary)
            })
            
            Card(content: {
                HStack {
                    Image(Images.rainDrop)
                        .resizable()
                        .frame(width: 32, height: 32)
                        .clipped()
                    Text("\(current.humidity, specifier: "%.0f")%")
                        .frame(maxWidth: .infinity)
                        .font(.footnote)
                }
                Text("data.humidity")
                    .font(.custom("Poppins-Light", size: 10))
                    .foregroundStyle(.secondary)
            })
        }
    }
}
