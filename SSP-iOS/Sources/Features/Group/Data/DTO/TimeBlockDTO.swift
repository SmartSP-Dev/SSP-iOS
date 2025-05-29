//
//  TimeBlockDTO.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/29/25.
//

import Foundation

struct TimeBlockDTO: Decodable {
    let dayOfWeek: String // 예: "MON"
    let time: String      // 예: "08:00"
    let weight: Int
    // blockMembers는 항상 null이므로 생략하거나 optional로 둬도 무방
}

extension TimeBlockDTO {
    func toTimeSlot(reference: Date) -> TimeSlot? {
        let weekdayMap = ["MON": 0, "TUE": 1, "WED": 2, "THU": 3, "FRI": 4, "SAT": 5, "SUN": 6]
        guard let offset = weekdayMap[dayOfWeek.uppercased()],
              let date = Calendar.current.date(byAdding: .day, value: offset, to: reference) else { return nil }

        let components = time.split(separator: ":")
        guard let hour = Int(components[0]), let minute = Int(components[1]) else { return nil }

        return TimeSlot(date: date, hour: hour, minute: minute)
    }
}
