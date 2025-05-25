//
//  QuizGenerateResponse.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/23/25.
//

import Foundation

struct QuizGenerateResponse: Decodable {
    let quizzes: [QuizGenerateQuestion]
}
