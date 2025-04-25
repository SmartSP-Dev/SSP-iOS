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
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .quizList:
                    QuizListView(viewModel: DIContainer.shared.makeQuizMainViewModel())
                case .study:
                    StudyView()
                default:
                    EmptyView()
                }
            }
        }

    }
}
