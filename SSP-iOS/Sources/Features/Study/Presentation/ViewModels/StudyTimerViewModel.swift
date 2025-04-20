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
    @Published var isPaused: Bool = false

    private var timer: Timer?

    func startStudy() {
        isStudying = true
        isPaused = false
        elapsedSeconds = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if !self.isPaused {
                self.elapsedSeconds += 1
            }
        }
    }
    
    func pause() {
        isPaused = true
    }
    
    func resume() {
        isPaused = false
    }

    func stopStudy() {
        isStudying = false
        timer?.invalidate()
        timer = nil
    }
}
