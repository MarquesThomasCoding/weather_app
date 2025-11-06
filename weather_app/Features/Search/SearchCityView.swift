//
//  SearchCityView.swift
//  weather_app
//
//  Created by MARQUES Thomas on 05/11/2025.
//

import SwiftUI
import DesignSystem

struct SearchCityView: View {
    @State var weatherViewModel = WeatherViewModel()
    @State private var cityViewModel = CityViewModel()
    @AppStorage("selectedCity") private var selectedCity: String = "Nanterre"
    @Environment(\.dismiss) private var dismiss
    
    init() {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
    }

    var body: some View {
        ZStack {
            Image(.backgroundCrepuscule)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .ignoresSafeArea()
            
            VStack {
                SearchField("city.entercitylabel", text: $selectedCity)
                    .padding()
                    .onChange(of: selectedCity) { oldValue, newValue in
                        Task {
                            await cityViewModel.fetchCities(for: newValue)
                        }
                    }

                if cityViewModel.isLoading {
                    ProgressView()
                        .padding()
                }
                
                Text("\(cityViewModel.cities.count) city.suggestions")

                Card(content: {
                    List(cityViewModel.cities) { item in
                        Button {
                            selectedCity = item.properties.formatted ?? ""
                            dismiss()
                        } label: {
                            Text(item.properties.formatted ?? "")
                                .lineLimit(1)
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparatorTint(.white)
                        .foregroundStyle(.white)
                    }
                    .background(Color.clear)
                    .scrollContentBackground(.hidden)
                })
                .padding()

                Spacer()

                ButtonPrimary(label: "city.validate", icon: "", action: {
                    dismiss()
                })
            }
        }
    }
}

#Preview {
    SearchCityView()
}
