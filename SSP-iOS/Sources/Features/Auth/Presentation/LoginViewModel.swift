//
//  LoginViewModel.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/8/25.
//

// ViewModel은 비즈니스 로직을 직접 알지 않음
// 대신 AuthUseCase를 주입받아 호출함으로써 의존성을 분리
// @Published로 UI 상태 연동
import Foundation
import SwiftUI

@MainActor
final class LoginViewModel: ObservableObject, LoginViewModelProtocol {
    @Published var isLoggedIn = false
    private let authUseCase: AuthUseCase
    private let kakaoUseCase: KakaoUseCase
    private let authNetworkService: AuthNetworkService

    init(authUseCase: AuthUseCase, kakaoUseCase: KakaoUseCase, authNetworkService: AuthNetworkService) {
        self.authUseCase = authUseCase
        self.kakaoUseCase = kakaoUseCase
        self.authNetworkService = authNetworkService
    }

    func loginWithApple() async {
        do {
            let code = try await authUseCase.loginWithApple()
            let token = try await authNetworkService.loginWithApple(code: code)
            
            // JWT 저장
            KeychainManager.shared.saveAccessToken(token.accessToken)
            KeychainManager.shared.saveRefreshToken(token.refreshToken)
            print("JWT 저장 완료: \(token.accessToken)")
            isLoggedIn = true
        } catch {
            print("애플 로그인 실패: \(error)")
        }
    }
    
    func loginWithKakao() async {
        do {
            _ = try await kakaoUseCase.loginWithKakao()
            isLoggedIn = true
        } catch {
            print("카카오 로그인 실패: \(error)")
        }
    }
}
