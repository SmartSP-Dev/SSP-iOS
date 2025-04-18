//
//  StudyViewModel.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/17/25.
//

import Foundation

final class StudyViewModel: ObservableObject {
    
    @Published var isStudying: Bool = false
    @Published var elapsedSeconds: Int = 0
    @Published var weeklyRecords: [WeeklyStudyRecord] = []
    @Published var selectedSubject: StudySubject?
    @Published var studyRecords: [DailyStudyRecord] = []
    
    private var timer: Timer?
    
    @Published var subjects: [StudySubject] = [
        StudySubject(name: "수학", time: 120),
        StudySubject(name: "영어", time: 90),
        StudySubject(name: "과학", time: 45),
        StudySubject(name: "코딩", time: 45),
        StudySubject(name: "독서", time: 45)
    ]
    
    init() {
        loadWeeklyRecords()
    }

    
    func addSubject(_ subject: StudySubject) {
        subjects.append(subject)
    }
    
    func removeSubject(_ subject: StudySubject) {
        subjects.removeAll { $0 == subject }
    }
    
    func updateSubject(_ subject: StudySubject) {
        if let index = subjects.firstIndex(where: { $0.id == subject.id }) {
            subjects[index] = subject
        }
    }
    
    func startStudy() {
        isStudying = true
        elapsedSeconds = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.elapsedSeconds += 1
        }
    }
    
    func stopStudy() {
        isStudying = false
        timer?.invalidate()
        timer = nil
    }
    
    func loadWeeklyRecords() {
        weeklyRecords = UserDefaults.standard.loadWeeklyRecords()
    }
    
    func saveWeeklyRecords() {
        UserDefaults.standard.saveWeeklyRecords(weeklyRecords)
    }
    
    func addTimeToSubject(_ subjectName: String, minutes: Int) {
        if let index = weeklyRecords.firstIndex(where: { $0.subjectName == subjectName }) {
            weeklyRecords[index].totalMinutes += minutes
        } else {
            weeklyRecords.append(WeeklyStudyRecord(subjectName: subjectName, totalMinutes: minutes))
        }
        saveWeeklyRecords()
    }
    func completeStudy(for elapsedSeconds: Int) {
        guard let subject = selectedSubject else { return }

        let minutes = elapsedSeconds / 60
        if minutes == 0 { return }

        addTimeToSubject(subject.name, minutes: minutes)
        saveDailyRecord(subjectName: subject.name, minutes: minutes)

        selectedSubject = nil
        saveWeeklyRecords()
    }
    
    private func saveDailyRecord(subjectName: String, minutes: Int) {
        let record = DailyStudyRecord(date: Date(), subjectName: subjectName, minutes: minutes)
        studyRecords.append(record)
    }
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

        guard let (date, minutes) = summed.max(by: { $0.value < $1.value }) else { return nil }
        return (date, minutes)
    }


}

