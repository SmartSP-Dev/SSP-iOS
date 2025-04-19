//
//  UserDefaults+Study.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/19/25.
//

import Foundation

extension UserDefaults {
    // MARK: - WeeklyStudyRecord 저장/로드

    private var weeklyKey: String { "weekly_study_records" }

    func saveWeeklyRecords(_ records: [WeeklyStudyRecord]) {
        if let encoded = try? JSONEncoder().encode(records) {
            set(encoded, forKey: weeklyKey)
        }
    }

    func loadWeeklyRecords() -> [WeeklyStudyRecord] {
        guard let data = data(forKey: weeklyKey),
              let decoded = try? JSONDecoder().decode([WeeklyStudyRecord].self, from: data) else {
            return []
        }
        return decoded
    }

    // MARK: - StudySubject 저장/로드

    private var subjectKey: String { "study_subjects" }

    func saveSubjects(_ subjects: [StudySubject]) {
        if let encoded = try? JSONEncoder().encode(subjects) {
            set(encoded, forKey: subjectKey)
        }
    }

    func loadSubjects() -> [StudySubject] {
        guard let data = data(forKey: subjectKey),
              let decoded = try? JSONDecoder().decode([StudySubject].self, from: data) else {
            return []
        }
        return decoded
    }
}
