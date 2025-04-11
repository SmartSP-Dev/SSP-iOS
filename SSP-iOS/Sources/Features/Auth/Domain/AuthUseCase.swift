//
//  AuthUseCase.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/8/25.
//

// 비즈니스 로직을 담당하는 계층
// ViewModel은 이 UseCase만 알고 있음 (Repository 구현체는 몰라도 됨)
// 테스트 용이성 및 의존성 분리 가능
import SwiftUI

protocol AuthUseCase {
    func loginWithApple() async throws -> String
}

final class DefaultAuthUseCase: AuthUseCase {
    private let repository: AuthRepository

    init(repository: AuthRepository) {
        self.repository = repository
    }

    func loginWithApple() async throws -> String {
        try await repository.loginWithApple()
    }
}

