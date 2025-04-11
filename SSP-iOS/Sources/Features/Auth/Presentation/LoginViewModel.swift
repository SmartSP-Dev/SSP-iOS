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

    init(authUseCase: AuthUseCase, kakaoUseCase: KakaoUseCase) {
        self.authUseCase = authUseCase
        self.kakaoUseCase = kakaoUseCase
    }

    func loginWithApple() async {
        do {
            _ = try await authUseCase.loginWithApple()
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
