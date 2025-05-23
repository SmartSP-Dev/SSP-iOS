//
//  FetchQuizDetailUseCase.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/23/25.
//

import Foundation

protocol FetchQuizDetailUseCase {
    func execute(quizId: Int) async throws -> [QuizQuestion]
}
