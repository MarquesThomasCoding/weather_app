//
//  ContentView.swift
//  weather_app
//
//  Created by MARQUES Thomas on 04/11/2025.
//
import SwiftUI
import DesignSystem

struct HomeView: View {
    @State var weatherViewModel = WeatherViewModel()
    @State private var isShowingSettings = false
    @AppStorage("isCelsius") private var isCelsius: Bool = true
    @AppStorage("selectedCity") private var selectedCity: String = "Nanterre"
    @State private var isShowingSearch = false
    
    var body: some View {
        ZStack {
            Image(weatherViewModel.backgroundImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .ignoresSafeArea()
            if let condition = weatherViewModel.weather?.current.condition.text,
               condition.lowercased().contains("rain") {
                RainView()
                    .ignoresSafeArea()
            }
            VStack {
                WeatherHeader(weatherViewModel: weatherViewModel, selectedCity: $selectedCity)
                if let current = weatherViewModel.weather?.current {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            let temp = isCelsius ? current.temp_c : current.temp_f
                            WeatherCurrentView(current: current, isCelsius: $isCelsius, temp: temp)
                            
                            if let forecastDays = weatherViewModel.weather?.forecast.forecastday {
                                Card(content: {
                                    WeatherHoursView(forecastDays: forecastDays, isCelsius: $isCelsius)
                                    
                                    Divider()
                                    
                                    WeatherForecastDays(forecastDays: forecastDays, isCelsius: $isCelsius)
                                }, spacing: 10)
                            }
                            
                            if let forecastDays = weatherViewModel.weather?.forecast.forecastday {
                                if let day = forecastDays.first {
                                    WeatherSunView(day: day)
                                    WeatherMoonView(weatherViewModel: weatherViewModel, day: day)
                                }
                            }
                            
                            if let current = weatherViewModel.weather?.current {
                                WeatherMoreInfosView(current: current)
                            }
                            Spacer()
                            VStack(alignment: .leading) {
                                ButtonPrimary(label: "home.gotosettings", icon: "gear", action: {
                                    isShowingSettings = true
                                })
                                ButtonPrimary(label: "home.gotocity", icon: "pencil", action: {
                                    isShowingSearch = true
                                })
                            }
                        }
                    }
                } else if weatherViewModel.isLoading {
                    ProgressView("home.loading")
                } else if let error = weatherViewModel.errorMessage {
                    Text("error.label \(error)")
                        .foregroundColor(.red)
                } else {
                    Text("error.nodata")
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 20)
        }
        .navigationDestination(isPresented: $isShowingSettings) {
            SettingsView()
        }
        .navigationDestination(isPresented: $isShowingSearch) {
            SearchCityView()
        }
        .task {
            await weatherViewModel.fetchWeather(for: "\(selectedCity)", days: 3)
        }
        .onChange(of: selectedCity) { oldValue, newValue in
            Task {
                await weatherViewModel.fetchWeather(for: "\(newValue)", days: 3)
            }
        }
    }
}


#Preview {
    HomeView()
}
