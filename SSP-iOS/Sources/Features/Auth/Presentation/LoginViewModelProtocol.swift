//
//  LoginViewModelProtocol.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/8/25.
//

// ViewModel을 프로토콜화해서 테스트(Mock) 가능하게 구성
// View에서 직접 ViewModel 구체 타입을 알 필요 없음 (의존성 역전)
import Foundation

@MainActor
protocol LoginViewModelProtocol: ObservableObject {
    var isLoggedIn: Bool { get set }
    func loginWithApple() async
    func loginWithKakao() async
    func autoLoginIfNeeded() async
}
