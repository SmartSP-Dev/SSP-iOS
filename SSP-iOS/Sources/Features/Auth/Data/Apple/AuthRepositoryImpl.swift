//
//  AuthRepositoryImpl.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/8/25.
//

// AuthRepository를 실제로 구현한 클래스
// 외부 AppleSignInService를 이용해서 실제 로그인 로직 수행
// UseCase → Repository Protocol → 이 구현체 호출 구조
import Foundation

final class DefaultAuthRepository: AuthRepository {
    private let service: AppleSignInService

    init(service: AppleSignInService) {
        self.service = service
    }

    func loginWithApple() async throws -> String {
        try await service.signIn()
    }
}
