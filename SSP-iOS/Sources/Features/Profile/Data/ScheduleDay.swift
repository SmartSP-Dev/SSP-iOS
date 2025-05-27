//
//  ScheduleDay.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/26/25.
//

import Foundation

struct ScheduleDay: Identifiable, Decodable {
    let id = UUID()
    let timePoint: String
    let subjects: [ScheduleSubject]

    enum CodingKeys: String, CodingKey {
        case timePoint = "time_point"
        case subjects
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.timePoint = try container.decode(String.self, forKey: .timePoint)
        self.subjects = try container.decode([ScheduleSubject].self, forKey: .subjects)
    }
}
