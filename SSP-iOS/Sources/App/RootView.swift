//
//  RootView.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/22/25.
//

import SwiftUI

struct RootView: View {
    @ObservedObject var loginViewModel: LoginViewModel
    @EnvironmentObject var appRouter: NavigationRouter

    var body: some View {
        NavigationStack(path: $appRouter.path) {
            Group {
                if loginViewModel.isLoggedIn {
                    MainTabView(loginViewModel: loginViewModel)
                        .environmentObject(DIContainer.shared)
                } else {
                    LoginView(viewModel: loginViewModel)
                }
            }
            .onAppear { // 자동 로그인
                if let token = KeychainManager.shared.accessToken, !token.isEmpty {
                    loginViewModel.isLoggedIn = true
                }
            }
            .task {
                await loginViewModel.autoLoginIfNeeded()
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .quizList:
                    QuizListView(viewModel: DIContainer.shared.makeQuizMainViewModel())
                case .quizCreate:
                    CreateQuizView(viewModel: DIContainer.shared.makeCreateQuizViewModel())
                case .study:
                    StudyView()
                case .groupHome:
                    GroupHomeView()
                case .quizSolve(let id):
                    QuizSolveView(
                        viewModel: QuizSolveViewModel(
                            quizId: id,
                            deleteQuizUseCase: DIContainer.shared.makeDeleteQuizUseCase(),
                            fetchQuizDetailUseCase: DIContainer.shared.makeFetchQuizDetailUseCase()
                        )
                    )
                case .quizResult(let id):
                    QuizResultView(quizId: id)
                case .groupAvailability(let group):
                    GroupAvailabilityView(group: group)
                case .groupSchedule(let group):
                    GroupScheduleView(group: group)
                default:
                    EmptyView()
                }
            }
        }

    }
}
