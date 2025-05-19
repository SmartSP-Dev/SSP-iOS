//
//  DIContainer.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/8/25.
//

import SwiftUI
import Moya

final class DIContainer: ObservableObject {
    static let shared = DIContainer()

    // MARK: - 앱 전역 라우터

    private(set) lazy var appRouter = NavigationRouter()
    @MainActor
    func makeAppRouter() -> NavigationRouter {
        return appRouter
    }

    // MARK: - 소셜 로그인 의존성 (Service → Repository → UseCase)

    /// Apple 로그인 서비스
    private let appleService = AppleSignInService()

    /// Kakao 로그인 서비스
    private let kakaoService = KakaoSignInService()

    /// Apple 로그인용 Repository
    private lazy var authRepository = DefaultAuthRepository(service: appleService)

    /// Kakao 로그인용 Repository
    private lazy var kakaoRepository = DefaultKakaoRepository(service: kakaoService)

    /// Apple 로그인 유즈케이스
    private lazy var authUseCase = DefaultAuthUseCase(repository: authRepository)

    /// Kakao 로그인 유즈케이스
    private lazy var kakaoUseCase = DefaultKakaoUseCase(repository: kakaoRepository)

    /// 로그인 네트워크 서비스
    private lazy var authNetworkService = DefaultAuthNetworkService(provider: MoyaProvider<AuthAPI>())

    /// 과목 저장소
    private lazy var subjectProvider = MoyaProvider<SubjectAPI>()
    lazy var subjectRepository = SubjectRepositoryImpl(provider: subjectProvider)

    // MARK: - 달력 관련 의존성

    /// 달력 저장소
    private lazy var calendarRepository = CalendarRepositoryImpl()

    /// 달력 유즈케이스
    private lazy var calendarUseCase = CalendarUseCase(repository: calendarRepository)

    // MARK: - 루틴 관련 의존성

    /// 로컬 루틴 저장소
    private lazy var routineRepository: RoutineRepository = {
        let remoteDataSource = RoutineRemoteDataSourceImpl()
        return RoutineRepositoryImpl(remote: remoteDataSource)
    }()
    
    // MARK: - 퀴즈 관련 의존성 (Service → Repository → UseCase)

    /// 퀴즈 저장소 구현체
    private lazy var quizRepository = QuizRepositoryImpl()

    /// 퀴즈 전체 조회 유즈케이스
    private lazy var fetchAllQuizUseCase = DefaultFetchAllQuizzesUseCase(repository: quizRepository)

    /// 복습 대상 퀴즈 조회 유즈케이스
    private lazy var fetchReviewQuizUseCase = DefaultFetchReviewTargetQuizzesUseCase(repository: quizRepository)

    // MARK: - ViewModel Factory

    /// 로그인 뷰모델 생성
    @MainActor
    func makeLoginViewModel() -> LoginViewModel {
        return LoginViewModel(
            authUseCase: authUseCase,
            kakaoUseCase: kakaoUseCase,
            authNetworkService: authNetworkService
        )
    }

    /// 메인 탭 뷰모델 생성
    @MainActor
    func makeMainTabViewModel() -> MainTabViewModel {
        return MainTabViewModel()
    }

    /// 달력 뷰모델 생성
    @MainActor
    func makeCalendarViewModel() -> CalendarViewModel {
        return CalendarViewModel(useCase: calendarUseCase)
    }

    /// 루틴 뷰모델 생성
    @MainActor
    func makeRoutineViewModel() -> RoutineViewModel {
        return RoutineViewModel(repository: routineRepository)
    }

    /// 퀴즈 메인 뷰모델 생성
    @MainActor
    func makeQuizMainViewModel() -> QuizMainViewModel {
        return QuizMainViewModel(
            fetchAllQuizzesUseCase: fetchAllQuizUseCase,
            fetchReviewTargetUseCase: fetchReviewQuizUseCase
        )
    }

    @MainActor
    func makeCreateQuizViewModel() -> CreateQuizViewModel {
        return CreateQuizViewModel(createQuizUseCase: DefaultCreateQuizUseCase(repository: quizRepository))
    }

}
