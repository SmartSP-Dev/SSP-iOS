//
//  CreateQuizRequest.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/27/25.
//

import Foundation

struct CreateQuizRequest {
    let fileURL: URL?
    let keyword: String
    let type: QuizType
}
