//
//  MockLoginViewModel.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/8/25.
//

// SwiftUI Preview 또는 테스트용 Mock ViewModel
// 실제 UseCase 호출하지 않고 프린트만 출력
import Foundation

@MainActor
final class MockLoginViewModel: LoginViewModelProtocol {
    @Published var isLoggedIn: Bool = true

    func loginWithApple() async {
        // do nothing
        print("로그인 시도!")
    }
    
    func loginWithKakao() async {
        // do nothing
        print("로그인 시도!")
    }
}

final class DummyAuthUseCase: AuthUseCase {
    func loginWithApple() async throws -> String {
        return "mock_user"
    }
}
