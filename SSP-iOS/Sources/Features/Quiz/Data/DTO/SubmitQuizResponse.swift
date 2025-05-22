//
//  SubmitQuizResponse.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/23/25.
//

import Foundation

struct SubmitQuizResponse: Decodable {
    let totalQuestions: Int
    let correctAnswers: Int
    let questionResults: [QuestionResult]

    struct QuestionResult: Decodable {
        let quizNumber: Int
        let questionTitle: String
        let userAnswer: String
        let correctAnswer: String
        let correct: Bool
    }
}
