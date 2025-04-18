//
//  WeeklyStudyRecord.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/18/25.
//

import Foundation

struct WeeklyStudyRecord: Codable, Identifiable {
    var id = UUID()
    let subjectName: String
    var totalMinutes: Int
}
