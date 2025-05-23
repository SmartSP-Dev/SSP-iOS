//
//  DefaultUploadFileUseCase.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/23/25.
//

import Foundation

final class DefaultUploadFileUseCase: UploadFileUseCase {
    private let repository: QuizRepositoryProtocol

    init(repository: QuizRepositoryProtocol) {
        self.repository = repository
    }

    func execute(fileURL: URL) async throws {
        try await repository.uploadFile(fileURL: fileURL)
    }
}
