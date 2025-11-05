//
//  SearchCityView.swift
//  weather_app
//
//  Created by MARQUES Thomas on 05/11/2025.
//

import SwiftUI
import DesignSystem

struct SearchCityView: View {
    @State private var cityViewModel = CityViewModel()
    @AppStorage("selectedCity") private var selectedCity: String = ""
    @Environment(\.dismiss) private var dismiss
    
    init() {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
    }

    var body: some View {
        ZStack {
            gradientDarkBlueToSkyBlue
                .ignoresSafeArea()
            VStack {
                TextField("city.entercitylabel", text: $selectedCity)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
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
