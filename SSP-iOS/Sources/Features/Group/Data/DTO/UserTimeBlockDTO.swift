//
//  UserTimeBlockDTO.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/30/25.
//

import Foundation

struct UserTimeBlockResponseDTO: Decodable {
    let timeBlocks: [UserTimeBlockDTO]
}

struct UserTimeBlockDTO: Codable {
    let dayOfWeek: String  // "MON", "TUE", ...
    let time: String       // "08:00", "08:30" ...
    let blockMembers: [BlockMemberDTO]

    init(from slot: TimeSlot) {
        self.dayOfWeek = slot.date.toDayOfWeekString()
        self.time = String(format: "%02d:%02d", slot.hour, slot.minute)
        self.blockMembers = []
    }

    func toTimeSlot(reference: Date) -> TimeSlot? {
        guard let date = reference.getDateOfWeek(dayOfWeek: dayOfWeek)?.onlyDate else { return nil }

        let parts = time.split(separator: ":")
        guard parts.count == 2,
              let hour = Int(parts[0]),
              let minute = Int(parts[1]) else { return nil }

        return TimeSlot(date: date, hour: hour, minute: minute)
    }
}
