//
//  StudyViewModel.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/17/25.
//

import Foundation

final class StudyViewModel: ObservableObject {
    @Published var subjects: [StudySubject] = [
        StudySubject(name: "수학", time: 120),
        StudySubject(name: "영어", time: 90),
        StudySubject(name: "과학", time: 45)
    ]
    
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
}

