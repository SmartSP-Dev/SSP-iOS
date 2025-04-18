//
//   UserDefaults+WeeklyRecord.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/18/25.
//

import Foundation

extension UserDefaults {
    private var key: String { "weekly_study_records" }

    func saveWeeklyRecords(_ records: [WeeklyStudyRecord]) {
        if let encoded = try? JSONEncoder().encode(records) {
            set(encoded, forKey: key)
        }
    }

    func loadWeeklyRecords() -> [WeeklyStudyRecord] {
        guard let data = data(forKey: key),
              let decoded = try? JSONDecoder().decode([WeeklyStudyRecord].self, from: data) else {
            return []
        }
        return decoded
    }
}
