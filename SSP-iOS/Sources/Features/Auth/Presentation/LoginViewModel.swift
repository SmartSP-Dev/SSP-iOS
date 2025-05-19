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
import Moya

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

    // MARK: - 소셜 로그인
    func loginWithApple() async {
        do {
            let code = try await authUseCase.loginWithApple()
            let token = try await authNetworkService.loginWithApple(code: code)
            
            // JWT 저장
            KeychainManager.shared.saveAccessToken(token.accessToken)
            KeychainManager.shared.saveRefreshToken(token.refreshToken)
            print("JWT 어세스 저장 완료: \(token.accessToken)")
            print("JWT 리프레시 저장 완료: \(token.refreshToken)")
            
            isLoggedIn = true
        } catch {
            print("애플 로그인 실패: \(error)")
        }
    }
    
    func loginWithKakao() async {
        do {
            let kakaoToken = try await kakaoUseCase.loginWithKakao()
            let jwtToken = try await authNetworkService.loginWithKakao(token: kakaoToken)

            // JWT 저장
            KeychainManager.shared.saveAccessToken(jwtToken.accessToken)
            KeychainManager.shared.saveRefreshToken(jwtToken.refreshToken)
            print("JWT 어세스 저장 완료: \(jwtToken.accessToken)")
            print("JWT 리프레시 저장 완료: \(jwtToken.refreshToken)")
            
            isLoggedIn = true
        } catch {
            print("카카오 로그인 실패: \(error)")
        }
    }
    
    // MARK: - 앱 시작 시 자동 로그인 + 토큰 만료 체크
   func autoLoginIfNeeded() async {
       guard let accessToken = KeychainManager.shared.accessToken,
             let payload = JWTDecoder.decode(token: accessToken) else {
           print("액세스 토큰 없음 또는 디코딩 실패")
           isLoggedIn = false
           return
       }

       let currentTime = Date().timeIntervalSince1970
       let remainingTime = payload.exp - currentTime

       if remainingTime < 10800 { // 3시간 이하
           print("남은 유효시간 3시간 미만 → 리프레시 시도")
           await refreshTokensIfNeeded()
       } else {
           print("유효한 액세스 토큰 → 자동 로그인")
           isLoggedIn = true
       }
   }

   private func refreshTokensIfNeeded() async {
       guard let refreshToken = KeychainManager.shared.refreshToken else {
           print("리프레시 토큰 없음")
           isLoggedIn = false
           return
       }
       print("저장된 refreshToken:", refreshToken)
       do {
           let newTokens = try await sendRefreshRequest(refreshToken: refreshToken)
           KeychainManager.shared.saveAccessToken(newTokens.accessToken)
           KeychainManager.shared.saveRefreshToken(newTokens.refreshToken)
           print("토큰 갱신 성공")
           isLoggedIn = true
       } catch {
           print("토큰 갱신 실패: \(error)")
           isLoggedIn = false
       }
    }

    private func sendRefreshRequest(refreshToken: String) async throws -> AuthTokenResponse {
        return try await withCheckedThrowingContinuation { continuation in
            let provider = MoyaProvider<AuthAPI>()
            provider.request(.refreshToken(token: refreshToken)) { result in
                switch result {
                case .success(let response):
                    guard (200..<300).contains(response.statusCode) else {
                        continuation.resume(throwing: NSError(domain: "", code: response.statusCode, userInfo: [
                            NSLocalizedDescriptionKey: "토큰 갱신 실패: \(response.statusCode)"
                        ]))
                        return
                    }

                    do {
                        let newTokens = try JSONDecoder().decode(AuthTokenResponse.self, from: response.data)
                        continuation.resume(returning: newTokens)
                    } catch {
                        continuation.resume(throwing: error)
                    }

                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
