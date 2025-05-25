//
//  QuizGenerateQuestion.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/25/25.
//

import Foundation

struct QuizGenerateQuestion: Decodable {
    let question: String
    let correct_answer: String
    let incorrect_answers: [String]
    let type: String
}
