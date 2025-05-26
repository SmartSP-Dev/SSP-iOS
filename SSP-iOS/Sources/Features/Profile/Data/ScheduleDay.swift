//
//  ScheduleDay.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/26/25.
//

import Foundation

struct ScheduleDay: Identifiable {
    let id = UUID()
    let timePoint: String
    let subjects: [ScheduleSubject]

    static let sampleData: [ScheduleDay] = [
        ScheduleDay(timePoint: "화", subjects: [
            ScheduleSubject(
                subject: "데이터베이스응용\n정영희정보과학관 21204 (김선행강의실)",
                times: ["16:30", "16:45", "17:00", "17:15", "17:30", "17:45", "18:00", "18:15", "18:30", "18:45", "19:00", "19:15"]
            )
        ]),
        ScheduleDay(timePoint: "수", subjects: [
            ScheduleSubject(
                subject: "컴퓨터비전응용\n류제철정보과학관 21201",
                times: ["13:30", "13:45", "14:00", "14:15", "14:30", "14:45"]
            ),
            ScheduleSubject(
                subject: "오픈소스기반고급설계\n김익수정보과학관 21203 (김재상강의실)",
                times: ["18:00", "18:15", "18:30", "18:45", "19:00", "19:15", "19:30", "19:45", "20:00", "20:15", "20:30", "20:45"]
            )
        ]),
        ScheduleDay(timePoint: "금", subjects: [
            ScheduleSubject(
                subject: "컴퓨터비전응용\n류제철정보과학관 21201",
                times: ["13:30", "13:45", "14:00", "14:15", "14:30", "14:45"]
            )
        ])
    ]
}

struct ScheduleSubject {
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
