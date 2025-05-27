//
//  TimetableResponse.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/28/25.
//

import Foundation

struct TimetableResponse: Decodable {
    let payload: SchedulePayload
}

struct SchedulePayload: Decodable {
    let schedules: [ScheduleDay]
}
