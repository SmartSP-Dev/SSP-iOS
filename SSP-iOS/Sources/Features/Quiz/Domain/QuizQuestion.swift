//
//  QuizQuestion.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/29/25.
//

import Foundation
import SwiftUI

public struct QuizQuestion: Decodable {
    let id: Int
    let questionTitle: String
    let correctAnswer: String
    let incorrectAnswers: [String]
    let questionType: String
    let quizNumber: Int

    enum CodingKeys: String, CodingKey {
        case id
        case questionTitle = "questionTitle"
        case correctAnswer = "correctAnswer"
        case incorrectAnswers = "incorrectAnswers"
        case questionType = "questionType"
        case quizNumber = "quizNumber"
    }

    var title: String { questionTitle }
    var type: QuizType { QuizType(from: questionType) }
    var answer: String { correctAnswer }
    var options: [String] { incorrectAnswers + [correctAnswer] }
}
