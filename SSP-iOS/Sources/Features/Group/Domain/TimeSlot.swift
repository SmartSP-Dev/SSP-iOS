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
