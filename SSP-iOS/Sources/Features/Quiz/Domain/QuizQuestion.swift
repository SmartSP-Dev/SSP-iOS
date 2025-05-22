//
//  QuizQuestion.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/29/25.
//

import Foundation
import SwiftUI

struct QuizQuestion: Decodable {
    let id: Int
    let questionTitle: String
    let quizNumber: Int
    let correctAnswer: String
    let incorrectAnswers: [String]
    let questionType: String

    var title: String { questionTitle }
    var type: QuizType {
        QuizType(from: questionType)
    }
    var answer: String { correctAnswer }
    var options: [String] { incorrectAnswers + [correctAnswer] }
}
