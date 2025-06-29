//
//  DIContainer.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/8/25.
//

import SwiftUI
import Moya

/// 의존성 주입 컨테이너 - 앱 전역에서 필요한 객체들을 생성하고 관리함
final class DIContainer: ObservableObject {
    /// 싱글톤 인스턴스
    static let shared = DIContainer()

    // MARK: - 앱 전역 라우터

    /// 네비게이션 경로를 관리하는 라우터 (SwiftUI NavigationStack용)
    private(set) lazy var appRouter = NavigationRouter()

    /// 외부에서 라우터를 가져올 때 사용하는 메서드 (MainActor 보장)
    @MainActor
    func makeAppRouter() -> NavigationRouter {
        return appRouter
    }

    // MARK: - 소셜 로그인 의존성 (Service → Repository → UseCase)

    /// Apple 로그인 서비스 객체
    private let appleService = AppleSignInService()

    /// Kakao 로그인 서비스 객체
    private let kakaoService = KakaoSignInService()

    /// Apple 로그인용 레포지토리
    private lazy var authRepository = DefaultAuthRepository(service: appleService)

    /// Kakao 로그인용 레포지토리
    private lazy var kakaoRepository = DefaultKakaoRepository(service: kakaoService)

    /// Apple 로그인 유즈케이스
    private lazy var authUseCase = DefaultAuthUseCase(repository: authRepository)

    /// Kakao 로그인 유즈케이스
    private lazy var kakaoUseCase = DefaultKakaoUseCase(repository: kakaoRepository)

    /// 로그인 관련 네트워크 요청 서비스
    private lazy var authNetworkService = DefaultAuthNetworkService(provider: MoyaProvider<AuthAPI>())

    /// 과목 관련 네트워크 제공자 및 레포지토리
    private lazy var subjectProvider = MoyaProvider<SubjectAPI>()
    lazy var subjectRepository = SubjectRepositoryImpl(provider: subjectProvider)

    // MARK: - 달력 관련 의존성

    /// 달력 데이터 로컬 저장소
    private lazy var calendarRepository = CalendarRepositoryImpl()

    /// 달력 비즈니스 로직 유즈케이스
    private lazy var calendarUseCase = CalendarUseCase(repository: calendarRepository)

    // MARK: - 루틴 관련 의존성

    /// 루틴 저장소 (리모트만 사용하는 구조)
    private lazy var routineRepository: RoutineRepository = {
        let remoteDataSource = RoutineRemoteDataSourceImpl()
        return RoutineRepositoryImpl(remote: remoteDataSource)
    }()
    
    // MARK: - 퀴즈 관련 의존성 (Service → Repository → UseCase)

    /// 퀴즈 관련 저장소
    private lazy var quizRepository = QuizRepositoryImpl()

    /// 전체 퀴즈 조회 유즈케이스
    private lazy var fetchAllQuizUseCase = DefaultFetchAllQuizzesUseCase(repository: quizRepository)

    /// 복습 대상 퀴즈 조회 유즈케이스
    private lazy var fetchReviewQuizUseCase = DefaultFetchReviewTargetQuizzesUseCase(repository: quizRepository)
    
    /// 퀴즈 삭제 유즈케이스
    private lazy var deleteQuizUseCase = DefaultDeleteQuizUseCase(repository: quizRepository)
    
    /// 주간 퀴즈 요약 유즈케이스
    private lazy var fetchQuizWeekSummaryUseCase = DefaultFetchQuizWeekSummaryUseCase(repository: quizRepository)
    
    /// 퀴즈 상세 조회 유즈케이스
    private lazy var fetchQuizDetailUseCase = DefaultFetchQuizDetailUseCase(repository: quizRepository)

    // MARK: - 시간표 관련 의존성

    private lazy var timetableRepository = TimetableRepositoryImpl(provider: MoyaProvider<TimetableAPI>())
    private lazy var saveTimetableLinkUseCase = DefaultSaveTimetableLinkUseCase(repository: timetableRepository)

    // MARK: - 사용자 프로필 관련 의존성

    private lazy var memberRepository = MemberRepositoryImpl(provider: MoyaProvider<MemberAPI>())
    private lazy var fetchMyProfileUseCase = DefaultFetchMyProfileUseCase(repository: memberRepository)
    
    private var updateProfileUseCase: UpdateProfileUseCase {
        DefaultUpdateProfileUseCase(repository: memberRepository)
    }

    // MARK: - 그룹 관련 의존성

    private lazy var groupRepository = GroupRepositoryImpl(provider: MoyaProvider<GroupAPI>())

    /// 외부에서 직접 그룹 레포지토리에 접근할 수 있도록 공개
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

    // MARK: - ViewModel Factory (ViewModel 생성기)

    /// 로그인 화면용 뷰모델
    @MainActor
    func makeLoginViewModel() -> LoginViewModel {
        return LoginViewModel(
            authUseCase: authUseCase,
            kakaoUseCase: kakaoUseCase,
            authNetworkService: authNetworkService
        )
    }

    /// 메인 탭 화면용 뷰모델
    @MainActor
    func makeMainTabViewModel() -> MainTabViewModel {
        return MainTabViewModel()
    }

    /// 달력 화면용 뷰모델
    @MainActor
    func makeCalendarViewModel() -> CalendarViewModel {
        return CalendarViewModel(useCase: calendarUseCase)
    }

    /// 루틴 화면용 뷰모델
    @MainActor
    func makeRoutineViewModel() -> RoutineViewModel {
        return RoutineViewModel(repository: routineRepository)
    }

    /// 퀴즈 메인 화면용 뷰모델
    @MainActor
    func makeQuizMainViewModel() -> QuizMainViewModel {
        return QuizMainViewModel(
            fetchAllQuizzesUseCase: fetchAllQuizUseCase,
            fetchReviewTargetUseCase: fetchReviewQuizUseCase,
            fetchQuizWeekSummaryUseCase: fetchQuizWeekSummaryUseCase
        )
    }

    /// 퀴즈 생성 화면용 뷰모델
    @MainActor
    func makeCreateQuizViewModel() -> CreateQuizViewModel {
        return CreateQuizViewModel(
            createQuizUseCase: DefaultCreateQuizUseCase(repository: quizRepository),
            uploadFileUseCase: DefaultUploadFileUseCase(repository: quizRepository)
        )
    }

    /// 퀴즈 삭제 유즈케이스 외부 제공
    @MainActor
    func makeDeleteQuizUseCase() -> DeleteQuizUseCase {
        return deleteQuizUseCase
    }

    /// 퀴즈 상세 조회 유즈케이스 외부 제공
    func makeFetchQuizDetailUseCase() -> FetchQuizDetailUseCase {
        return fetchQuizDetailUseCase
    }

    /// 시간표 링크 저장 뷰모델
    @MainActor
    func makeTimetableLinkViewModel() -> TimetableLinkViewModel {
        return TimetableLinkViewModel(
            useCase: saveTimetableLinkUseCase,
            repository: timetableRepository
        )
    }

    /// 프로필 화면용 뷰모델
    @MainActor
    func makeProfileViewModel() -> ProfileViewModel {
        ProfileViewModel(
            fetchProfileUseCase: fetchMyProfileUseCase,
            updateProfileUseCase: updateProfileUseCase
        )
    }

    /// 그룹 홈 화면용 뷰모델
    @MainActor
    func makeGroupHomeViewModel() -> GroupHomeViewModel {
        return GroupHomeViewModel(
            fetchMyGroupsUseCase: fetchMyGroupsUseCase,
            createGroupUseCase: createGroupUseCase,
            joinGroupUseCase: joinGroupUseCase
        )
    }

    /// 그룹 생성 유즈케이스 외부 제공
    @MainActor
    func makeCreateGroupUseCase() -> CreateGroupUseCase {
        return createGroupUseCase
    }

    /// 그룹 스케줄 화면용 뷰모델
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

    /// 그룹 시간 가용성 화면용 뷰모델
    @MainActor
    func makeGroupAvailabilityViewModel(group: ScheduleGroup) -> GroupAvailabilityViewModel {
        GroupAvailabilityViewModel(
            group: group,
            fetchWeightAndMembersUseCase: fetchWeightAndMembersUseCase,
            groupRepository: groupRepository
        )
    }

    /// 가중치 및 멤버 조회 유즈케이스 외부 제공
    @MainActor
    func makeFetchWeightAndMembersUseCase() -> FetchWeightAndMembersUseCase {
        return fetchWeightAndMembersUseCase
    }
}
