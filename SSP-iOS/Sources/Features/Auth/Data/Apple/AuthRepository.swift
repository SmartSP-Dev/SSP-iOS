//
//  AuthRepository.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/8/25.
//

// Auth 도메인의 추상화 계층 (Interface)
// UseCase가 이 인터페이스를 통해 데이터를 요청
// Clean Architecture의 핵심 규칙 중 하나: 상위 레이어는 하위 레이어 구현에 의존하지 않음
import Foundation

protocol AuthRepository {
    func loginWithApple() async throws -> String
}
