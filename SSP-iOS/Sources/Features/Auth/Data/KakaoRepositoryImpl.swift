//
//  KakaoRepositoryImpl.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/13/25.
//

import Foundation

final class DefaultKakaoRepository: KakaoRepository {
    private let service: KakaoSignInService

    init(service: KakaoSignInService) {
        self.service = service
    }

    func loginWithKakao() async throws -> String {
        try await service.signIn()
    }
}
