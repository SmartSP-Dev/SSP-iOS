//
//  SubmitQuizRequest.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/20/25.
//

import Foundation

struct SubmitQuizRequest: Encodable {
    let quizId: Int
    let answers: [Answer]

    struct Answer: Encodable {
        let quizNumber: Int
        let userAnswer: String
    }
}
