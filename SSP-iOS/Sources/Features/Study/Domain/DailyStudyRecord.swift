//
//  DailyStudyRecord.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/18/25.
//

import Foundation

struct DailyStudyRecord: Identifiable, Codable {
    let id = UUID()
    let date: Date
    let subjectName: String
    let minutes: Int
}
