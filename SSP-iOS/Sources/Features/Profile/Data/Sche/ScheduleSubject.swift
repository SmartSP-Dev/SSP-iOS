//
//  ScheduleSubject.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/28/25.
//

import Foundation

struct ScheduleSubject: Decodable {
    let subject: String
    let times: [String]

    var titleLine: String {
        subject.components(separatedBy: "\n").first ?? subject
    }

    var locationLine: String {
        subject.components(separatedBy: "\n").dropFirst().joined(separator: " ")
    }

    var timeRange: String {
        guard let start = times.first, let end = times.last else { return "-" }
        return "\(start) ~ \(end)"
    }
}
