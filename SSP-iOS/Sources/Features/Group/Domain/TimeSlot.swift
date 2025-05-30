//
//  TimeSlot.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/8/25.
//

import Foundation

struct TimeSlot: Hashable {
    let date: Date
    let hour: Int
    let minute: Int

    init(date: Date, hour: Int, minute: Int = 0) {
        self.date = Calendar.current.startOfDay(for: date) 
        self.hour = hour
        self.minute = minute
    }

    static func == (lhs: TimeSlot, rhs: TimeSlot) -> Bool {
        return Calendar.current.isDate(lhs.date, inSameDayAs: rhs.date)
            && lhs.hour == rhs.hour
            && lhs.minute == rhs.minute
    }

    func hash(into hasher: inout Hasher) {
        let day = Calendar.current.startOfDay(for: date)
        hasher.combine(day)
        hasher.combine(hour)
        hasher.combine(minute)
    }
}

extension TimeSlot {
    func toTimeBlockDict() -> [String: String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "E" // e.g., "Mon"
        formatter.locale = Locale(identifier: "en_US_POSIX")

        let weekday = Calendar.current.component(.weekday, from: date)
        let dayOfWeek = ["SUN","MON","TUE","WED","THU","FRI","SAT"][weekday - 1]
        let timeString = String(format: "%02d:%02d", hour, minute)

        return [
            "dayOfWeek": dayOfWeek,
            "time": timeString
        ]
    }
}
