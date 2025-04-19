//
//  SubjectManageViewModel.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/19/25.
//

import Foundation

final class SubjectManageViewModel: ObservableObject {
    @Published var subjects: [StudySubject] = []

    init() {
        loadSubjects()
    }

    func addSubject(_ subject: StudySubject) {
        subjects.append(subject)
        saveSubjects()
    }

    func removeSubject(_ subject: StudySubject) {
        subjects.removeAll { $0 == subject }
        saveSubjects()
    }

    func updateSubject(_ subject: StudySubject) {
        if let index = subjects.firstIndex(where: { $0.id == subject.id }) {
            subjects[index] = subject
            saveSubjects()
        }
    }

    private func loadSubjects() {
        self.subjects = UserDefaults.standard.loadSubjects()
    }

    private func saveSubjects() {
        UserDefaults.standard.saveSubjects(subjects)
    }
}
