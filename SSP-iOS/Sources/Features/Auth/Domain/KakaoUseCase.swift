//
//  KakaoUseCase.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/13/25.
//

import Foundation

protocol KakaoUseCase {
    func loginWithKakao() async throws -> String
}

final class DefaultKakaoUseCase: KakaoUseCase {
    private let repository: KakaoRepository

    init(repository: KakaoRepository) {
        self.repository = repository
    }

    func loginWithKakao() async throws -> String {
        try await repository.loginWithKakao()
    }
}
