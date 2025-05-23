//
//  CreateQuizUseCase.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/27/25.
//

import Foundation

protocol CreateQuizUseCase {
    func execute(request: CreateQuizRequest) async throws -> Quiz
}
