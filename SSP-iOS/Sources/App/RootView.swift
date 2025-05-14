//
//  RootView.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/22/25.
//

import SwiftUI

struct RootView: View {
    @ObservedObject var loginViewModel: LoginViewModel
    @StateObject private var appRouter = DIContainer.shared.makeAppRouter()

    var body: some View {
        NavigationStack(path: $appRouter.path) {
            Group {
                if loginViewModel.isLoggedIn {
                    MainTabView()
                        .environmentObject(DIContainer.shared)
                } else {
                    LoginView(viewModel: loginViewModel)
                }
            }
            .onAppear {
                if let token = KeychainManager.shared.accessToken, !token.isEmpty {
                    loginViewModel.isLoggedIn = true
                }
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
                default:
                    EmptyView()
                }
            }
        }

    }
}
