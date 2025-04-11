//
//  KakaoSignInService.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/13/25.
//

// Kakao 로그인을 실제로 수행하는 카카오 SDK 연동 서비스
// 외부 SDK (KakaoSDKAuth, KakaoSDKUser) 와 직접 통신
import Foundation
import KakaoSDKAuth
import KakaoSDKUser

/// Kakao 로그인 로직을 담당하는 서비스 클래스
/// 실제 API 요청을 처리하며, accessToken을 반환
final class KakaoSignInService {
    
    /// 카카오 로그인 시도 (카카오톡 앱 또는 계정 로그인)
    /// 성공 시 access token 문자열을 반환
    func signIn() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            
            // 카카오톡 앱이 설치되어 있는 경우
            if UserApi.isKakaoTalkLoginAvailable() {
                // 카카오톡 앱을 통한 로그인 시도
                UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                    if let error = error {
                        // 에러 발생 시 continuation 종료
                        continuation.resume(throwing: error)
                    } else if let token = oauthToken {
                        // access token 반환
                        continuation.resume(returning: token.accessToken)
                    } else {
                        // 토큰도 에러도 없는 이상한 상황 → 강제 오류
                        continuation.resume(throwing: NSError(
                            domain: "KakaoSignIn",
                            code: -1,
                            userInfo: [NSLocalizedDescriptionKey: "No token received"]
                        ))
                    }
                }
            }
            // 카카오톡 앱이 없으면 카카오 계정으로 로그인
            else {
                UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else if let token = oauthToken {
                        continuation.resume(returning: token.accessToken)
                    } else {
                        continuation.resume(throwing: NSError(
                            domain: "KakaoSignIn",
                            code: -1,
                            userInfo: [NSLocalizedDescriptionKey: "No token received"]
                        ))
                    }
                }
            }
        }
    }
}
