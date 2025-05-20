//
//  FetchQuizListResponse.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/20/25.
//

import Foundation

struct FetchQuizListResponse: Decodable {
    let quizId: Int
    let title: String
    let keywords: String
    let questionType: String
    let createdAt: String 
}
