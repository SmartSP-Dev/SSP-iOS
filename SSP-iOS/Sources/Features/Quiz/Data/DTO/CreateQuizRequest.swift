//
//  CreateQuizRequest.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/23/25.
//

import Foundation

struct CreateQuizRequest {
    let title: String
    let keyword: String
    let type: QuizType
    let fileURL: URL?
}
