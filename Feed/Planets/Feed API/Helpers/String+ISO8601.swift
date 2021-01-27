//
//  String+ISO8601.swift
//  Planets
//
//  Created by Valentin Kalchev (Zuant) on 24/01/21.
//

import Foundation

public extension String {
    func isoFormattedDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        return dateFormatter.date(from: self)
    }
}
