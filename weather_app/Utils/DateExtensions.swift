//
//  Date+Extensions.swift.swift
//  weather_app
//
//  Created by MARQUES Thomas on 05/11/2025.
//

import SwiftUI

extension Date {
    func dayOfWeek(locale: Locale = Locale.current) -> String {
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.dateFormat = "EEEE"
        return formatter.string(from: self)
    }
}
