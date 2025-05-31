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
    
    private lazy var deleteQuizUseCase = DefaultDeleteQuizUseCase(repository: quizRepository)
    
    private lazy var fetchQuizWeekSummaryUseCase = DefaultFetchQuizWeekSummaryUseCase(repository: quizRepository)
    
    private lazy var fetchQuizDetailUseCase = DefaultFetchQuizDetailUseCase(repository: quizRepository)
    
    private lazy var timetableRepository = TimetableRepositoryImpl(provider: MoyaProvider<TimetableAPI>())
    private lazy var saveTimetableLinkUseCase = DefaultSaveTimetableLinkUseCase(repository: timetableRepository)
    
    private lazy var memberRepository = MemberRepositoryImpl(provider: MoyaProvider<MemberAPI>())
    private lazy var fetchMyProfileUseCase = DefaultFetchMyProfileUseCase(repository: memberRepository)

    private var updateProfileUseCase: UpdateProfileUseCase {
        DefaultUpdateProfileUseCase(repository: memberRepository)
    }
    
    private lazy var groupRepository = GroupRepositoryImpl(provider: MoyaProvider<GroupAPI>())
    
    var exposedGroupRepository: GroupRepository {
        return groupRepository
    }
    
    private lazy var fetchMyGroupsUseCase = DefaultFetchMyGroupsUseCase(repository: groupRepository)

    private lazy var createGroupUseCase = DefaultCreateGroupUseCase(repository: groupRepository)
    private lazy var joinGroupUseCase = DefaultJoinGroupUseCase(repository: groupRepository)
    
    private lazy var fetchUserScheduleUseCase = DefaultFetchUserScheduleUseCase(repository: groupRepository)
    private lazy var saveUserScheduleUseCase = DefaultSaveUserScheduleUseCase(repository: groupRepository)

    private lazy var fetchGroupTimetableUseCase = DefaultFetchGroupTimetableUseCase(repository: groupRepository)

    private lazy var fetchWeightAndMembersUseCase = DefaultFetchWeightAndMembersUseCase(repository: groupRepository)

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
            fetchReviewTargetUseCase: fetchReviewQuizUseCase,
            fetchQuizWeekSummaryUseCase: fetchQuizWeekSummaryUseCase
        )
    }

    @MainActor
    func makeCreateQuizViewModel() -> CreateQuizViewModel {
        return CreateQuizViewModel(
            createQuizUseCase: DefaultCreateQuizUseCase(repository: quizRepository),
            uploadFileUseCase: DefaultUploadFileUseCase(repository: quizRepository)
            )
    }
    
    @MainActor
    func makeDeleteQuizUseCase() -> DeleteQuizUseCase {
        return deleteQuizUseCase
    }
    
    func makeFetchQuizDetailUseCase() -> FetchQuizDetailUseCase {
        return fetchQuizDetailUseCase
    }
    
    @MainActor
    func makeTimetableLinkViewModel() -> TimetableLinkViewModel {
        return TimetableLinkViewModel(
            useCase: saveTimetableLinkUseCase,
            repository: timetableRepository 
        )
    }
    @MainActor
    func makeProfileViewModel() -> ProfileViewModel {
        ProfileViewModel(
            fetchProfileUseCase: fetchMyProfileUseCase,
            updateProfileUseCase: updateProfileUseCase
        )
    }
    
    @MainActor
    func makeGroupHomeViewModel() -> GroupHomeViewModel {
        return GroupHomeViewModel(
            fetchMyGroupsUseCase: fetchMyGroupsUseCase,
            createGroupUseCase: createGroupUseCase,
            joinGroupUseCase: joinGroupUseCase
        )
    }
    
    @MainActor
    func makeCreateGroupUseCase() -> CreateGroupUseCase {
        return createGroupUseCase
    }
    
    @MainActor
    func makeGroupScheduleViewModel(group: ScheduleGroup) -> GroupScheduleViewModel {
        GroupScheduleViewModel(
            group: group,
            fetchUserScheduleUseCase: fetchUserScheduleUseCase,
            saveUserScheduleUseCase: saveUserScheduleUseCase,
            fetchGroupTimetableUseCase: fetchGroupTimetableUseCase,
            timetableRepository: timetableRepository
        )
    }
    
    @MainActor
    func makeGroupAvailabilityViewModel(group: ScheduleGroup) -> GroupAvailabilityViewModel {
        GroupAvailabilityViewModel(
            group: group,
            fetchWeightAndMembersUseCase: fetchWeightAndMembersUseCase, groupRepository: groupRepository
        )
    }
    
    @MainActor
    func makeFetchWeightAndMembersUseCase() -> FetchWeightAndMembersUseCase {
        return fetchWeightAndMembersUseCase
    }
}
