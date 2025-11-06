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
                HStack {
                    if let location = weatherViewModel.weather?.location {
                        Text("\(location.name), \(location.region)")
                            .font(.title3)
                            .foregroundColor(.black.opacity(0.7))
                    }
                    Spacer()
                    ButtonPrimary(label: "", icon: "arrow.2.circlepath") {
                        Task {
                            await weatherViewModel.fetchWeather(for: "\(selectedCity)", days: 3)
                        }
                    }
                }
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        if let current = weatherViewModel.weather?.current {
                            let temp = isCelsius ? current.temp_c : current.temp_f
                            HStack {
                                Card(content: {
                                    let localizedCurrentWeatherText = NSLocalizedString(current.condition.text, comment: "")
                                    
                                    Text("\(String(format: "%.1f", temp)) °\(isCelsius ? "C" : "F")")
                                        .font(.largeTitle)
                                    Text(localizedCurrentWeatherText)
                                })
                                Spacer()
                                Image(Images.fromConditionIcon(current.condition.text))
                                    .resizable()
                                    .frame(width: 128, height: 128)
                                Spacer()
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
                        
                        if let forecastDays = weatherViewModel.weather?.forecast.forecastday {
                            Card(content: {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        if let hours = forecastDays.first?.hour {
                                            ForEach(hours) { hour in
                                                let hourTemp = isCelsius ? hour.temp_c : hour.temp_f
                                                let iconString = hour.condition.text
                                                let iconResource = Images.fromConditionIcon(iconString)
                                                WeatherHourCard(
                                                    hour: hour.time.components(separatedBy: " ").last ?? "",
                                                    icon: iconResource,
                                                    temperature: "\(Int(hourTemp))°\(isCelsius ? "C" : "F")",
                                                    chance_of_rain: hour.chance_of_rain
                                                )
                                            }
                                        }
                                    }
                                }
                                
                                Divider()
                                
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
                            }, spacing: 10)
                        }
                        
                        if let forecastDays = weatherViewModel.weather?.forecast.forecastday {
                            if let day = forecastDays.first {
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
                        
                        if let current = weatherViewModel.weather?.current {
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
