//
//  AppleSignInService.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/8/25.
//

// Apple 로그인을 실제로 수행하는 Apple 공식 프레임워크 연동 서비스
// 외부 SDK(ASAuthorizationController)와 직접적으로 통신
import Foundation
import AuthenticationServices

final class AppleSignInService: NSObject {
    private var delegateHolder: AppleSignInDelegate?

    /// Apple 로그인 시도, 성공 시 authorization code(String)를 반환
    func signIn() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = [.fullName, .email]

            let controller = ASAuthorizationController(authorizationRequests: [request])

            Task { @MainActor in
                let delegate = AppleSignInDelegate(continuation: continuation)
                self.delegateHolder = delegate
                controller.delegate = delegate
                controller.performRequests()
            }
        }
    }
}

@MainActor
final class AppleSignInDelegate: NSObject, ASAuthorizationControllerDelegate {
    let continuation: CheckedContinuation<String, Error>

    init(continuation: CheckedContinuation<String, Error>) {
        self.continuation = continuation
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard
            let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
            let codeData = credential.authorizationCode,
            let code = String(data: codeData, encoding: .utf8)
        else {
            continuation.resume(throwing: NSError(
                domain: "AppleSignIn",
                code: -2,
                userInfo: [NSLocalizedDescriptionKey: "Failed to extract authorization code"]
            ))
            return
        }

        continuation.resume(returning: code) 
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        continuation.resume(throwing: error)
    }
}
