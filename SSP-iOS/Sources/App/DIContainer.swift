//
//  DIContainer.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/8/25.
//

import SwiftUI

final class DIContainer {
    static let shared = DIContainer()

    private let appleService = AppleSignInService()
    private let kakaoService = KakaoSignInService()

    private lazy var authRepository = DefaultAuthRepository(service: appleService)
    private lazy var kakaoRepository = DefaultKakaoRepository(service: kakaoService)

    private lazy var authUseCase = DefaultAuthUseCase(repository: authRepository)
    private lazy var kakaoUseCase = DefaultKakaoUseCase(repository: kakaoRepository)

    @MainActor
    func makeLoginViewModel() -> LoginViewModel {
        return LoginViewModel(authUseCase: authUseCase, kakaoUseCase: kakaoUseCase)
    }
    
    @MainActor
    func makeMainTabViewModel() -> MainTabViewModel {
        return MainTabViewModel()
    }
}
