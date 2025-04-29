//
//  QuizSolveViewModel.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/29/25.
//

import Foundation

final class QuizSolveViewModel: ObservableObject {
    @Published var currentIndex: Int = 0
    @Published var quizzes: [QuizQuestion] = []
    @Published var selectedAnswer: String? = nil
    @Published var showAnswer: Bool = false
    @Published var isFinished: Bool = false

    init() {
        self.quizzes = MockQuizData.sampleQuestions
    }

    var currentQuestion: QuizQuestion {
        quizzes[currentIndex]
    }

    func submitAnswer() {
        showAnswer = true
    }

    func nextQuestion() {
        if currentIndex + 1 >= quizzes.count {
            isFinished = true
            return
        }
        currentIndex += 1
        selectedAnswer = nil
        showAnswer = false
    }
}
