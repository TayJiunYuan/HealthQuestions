//
//  Date+Extensions.swift
//  HealthQuestions
//
//  Created by Tay Jiun Yuan on 11/6/25.
//

import Foundation

private extension DateFormatter {
    static let yyyyMMdd: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyyMMdd"
        df.locale     = Locale(identifier: "en_US_POSIX")   // stable, culture-agnostic
        df.calendar   = Calendar(identifier: .gregorian)     // avoids non-Gregorian calendars
        return df
    }()
}

extension String {
    var asDate_yyyyMMdd: Date? {
        DateFormatter.yyyyMMdd.date(from: self)
    }
}

extension Date {
    var yyyyMMddString: String {
        DateFormatter.yyyyMMdd.string(from: self)
    }
}
