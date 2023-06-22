//
//  Date+Extension.swift
//  APOD
//
//  Created by Pachauri, Ankur on 15/06/23.
//

import Foundation

extension Date {
    static var dateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    func toDateString() -> String {
        return Self.dateFormatter.string(from: self)
    }
}
