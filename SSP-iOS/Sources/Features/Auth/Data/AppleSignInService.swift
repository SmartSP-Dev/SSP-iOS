//
//  AppleSignInService.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/8/25.
//

// Apple 로그인을 실제로 수행하는 Apple 공식 프레임워크 연동 서비스
// 외부 SDK(ASAuthorizationController)와 직접적으로 통신
import Foundation
import AuthenticationServices  // Apple 로그인에 필요한 프레임워크

// Apple 로그인 로직을 담당하는 서비스 클래스 (실제 API 요청 담당)
final class AppleSignInService: NSObject {
    private var delegateHolder: AppleSignInDelegate?  // 비동기 처리를 위한 delegate를 참조 유지

    // Apple 로그인 시도, 성공 시 user identifier(String)를 반환
    func signIn() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            // Apple 로그인 요청 객체 생성
            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = [.fullName, .email]  // 사용자 정보 요청 범위 지정

            // 로그인 컨트롤러에 요청을 전달
            let controller = ASAuthorizationController(authorizationRequests: [request])

            Task { @MainActor in
                // 결과를 비동기적으로 처리하기 위한 delegate 설정
                let delegate = AppleSignInDelegate(continuation: continuation)
                self.delegateHolder = delegate  // delegate 참조 유지 안 하면 GC로 사라짐
                controller.delegate = delegate  // 실제 결과 받을 델리게이트 설정
                controller.performRequests()    // 로그인 요청 실행
            }
        }
    }
}

// Apple 로그인 결과를 처리할 델리게이트
@MainActor
final class AppleSignInDelegate: NSObject, ASAuthorizationControllerDelegate {
    let continuation: CheckedContinuation<String, Error>  // 비동기 처리를 위한 continuation 객체

    init(continuation: CheckedContinuation<String, Error>) {
        self.continuation = continuation
    }

    // 로그인 성공 시 호출되는 콜백
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            continuation.resume(returning: credential.user)  // 유저 식별자 반환
        } else {
            continuation.resume(throwing: NSError(domain: "AppleSignIn", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid credential"]))
        }
    }

    // 로그인 실패 시 호출되는 콜백
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        continuation.resume(throwing: error)
    }
}
