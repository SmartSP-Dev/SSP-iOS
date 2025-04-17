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
    private var timer: Timer?
    
    @Published var subjects: [StudySubject] = [
        StudySubject(name: "수학", time: 120),
        StudySubject(name: "영어", time: 90),
        StudySubject(name: "과학", time: 45),
        StudySubject(name: "코딩", time: 45),
        StudySubject(name: "독서", time: 45)
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
}

