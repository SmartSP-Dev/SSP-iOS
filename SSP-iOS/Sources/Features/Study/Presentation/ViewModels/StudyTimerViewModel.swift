//
//  StudyTimerViewModel.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/19/25.
//

import Foundation

final class StudyTimerViewModel: ObservableObject {
    @Published var isStudying: Bool = false
    @Published var elapsedSeconds: Int = 0
    @Published var selectedSubject: StudySubject?

    private var timer: Timer?

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
