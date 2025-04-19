//
//  StatisticsViewModel.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/19/25.
//

import Foundation

final class StatisticsViewModel: ObservableObject {
    @Published var weeklyRecords: [WeeklyStudyRecord] = []
    @Published var studyRecords: [DailyStudyRecord] = []

    init() {
        loadWeeklyRecords()
    }

    func addTimeToSubject(_ subjectName: String, minutes: Int) {
        if let index = weeklyRecords.firstIndex(where: { $0.subjectName == subjectName }) {
            weeklyRecords[index].totalMinutes += minutes
        } else {
            weeklyRecords.append(WeeklyStudyRecord(subjectName: subjectName, totalMinutes: minutes))
        }
        saveWeeklyRecords()
    }

    func completeStudy(subjectName: String, elapsedSeconds: Int) {
        let minutes = elapsedSeconds / 60
        guard minutes > 0 else { return }

        addTimeToSubject(subjectName, minutes: minutes)
        saveDailyRecord(subjectName: subjectName, minutes: minutes)
    }

    private func saveDailyRecord(subjectName: String, minutes: Int) {
        let record = DailyStudyRecord(date: Date(), subjectName: subjectName, minutes: minutes)
        studyRecords.append(record)
    }

    // MARK: 통계 계산

    var totalStudyDays: Int {
        Set(studyRecords.map { Calendar.current.startOfDay(for: $0.date) }).count
    }

    var totalMonthlyMinutes: Int {
        studyRecords.reduce(0) { $0 + $1.minutes }
    }

    var averageMinutesPerDay: Double {
        guard totalStudyDays > 0 else { return 0 }
        return Double(totalMonthlyMinutes) / Double(totalStudyDays)
    }

    var bestStudyDayFormatted: String {
        guard let best = bestStudyDay else { return "-" }
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 d일"
        return formatter.string(from: best.date)
    }

    var bestStudyDayMinutes: Int {
        bestStudyDay?.minutes ?? 0
    }

    private var bestStudyDay: (date: Date, minutes: Int)? {
        let grouped = Dictionary(grouping: studyRecords, by: { Calendar.current.startOfDay(for: $0.date) })
        let summed = grouped.mapValues { $0.reduce(0) { $0 + $1.minutes } }
        return summed.max(by: { $0.value < $1.value }).map { ($0.key, $0.value) }
    }

    // MARK: 저장

    private func loadWeeklyRecords() {
        weeklyRecords = UserDefaults.standard.loadWeeklyRecords()
    }

    private func saveWeeklyRecords() {
        UserDefaults.standard.saveWeeklyRecords(weeklyRecords)
    }
}
