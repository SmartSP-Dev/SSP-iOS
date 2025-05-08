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
        self.date = date
        self.hour = hour
        self.minute = minute
    }
}

enum SlotType {
    case available
    case busyFromSchedule
    case busyFromEvent
}
