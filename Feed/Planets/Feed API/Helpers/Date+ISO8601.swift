//
//  Date+ISO8601.swift
//  Planets
//
//  Created by Valentin Kalchev (Zuant) on 23/01/21.
//

import Foundation

public extension Date {
    func iso8601FormattedString() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        return dateFormatter.string(from: self)
    }
}
