//
//  DIContainer.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/8/25.
//

import SwiftUI

final class DIContainer {
    static let shared = DIContainer()

    // 소셜 로그인
    private let appleService = AppleSignInService()
    private let kakaoService = KakaoSignInService()

    private lazy var authRepository = DefaultAuthRepository(service: appleService)
    private lazy var kakaoRepository = DefaultKakaoRepository(service: kakaoService)

    private lazy var authUseCase = DefaultAuthUseCase(repository: authRepository)
    private lazy var kakaoUseCase = DefaultKakaoUseCase(repository: kakaoRepository)
    
    // 커스텀 달력
    private lazy var calendarRepository = CalendarRepositoryImpl()
    private lazy var calendarUseCase = CalendarUseCase(repository: calendarRepository)

    @MainActor
    func makeCalendarViewModel() -> CalendarViewModel {
        return CalendarViewModel(useCase: calendarUseCase)
    }

    @MainActor
    func makeLoginViewModel() -> LoginViewModel {
        return LoginViewModel(authUseCase: authUseCase, kakaoUseCase: kakaoUseCase)
    }
    
    @MainActor
    func makeMainTabViewModel() -> MainTabViewModel {
        return MainTabViewModel()
    }
    
    @MainActor
    func makeRoutineViewModel() -> RoutineViewModel {
        let repository = LocalRoutineRepository()
        return RoutineViewModel(repository: repository)
    }
}
