//
//  QuizListView.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/22/25.
//

import SwiftUI

struct QuizListView: View {
    @StateObject private var viewModel: QuizMainViewModel

    init(viewModel: QuizMainViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                titleSection
                contentSection
            }
            .padding(.top)
        }
        .background(Color.white)
        .navigationTitle("내 퀴즈")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                backButton
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchAll()
            }
        }
    }
    private var titleSection: some View {
        Text("전체 퀴즈 목록")
            .font(.title2)
            .bold()
            .padding(.horizontal)
    }

    private var contentSection: some View {
        if viewModel.allQuizzes.isEmpty {
            return AnyView(
                Text("아직 생성된 퀴즈가 없어요.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
            )
        } else {
            return AnyView(
                ForEach(viewModel.allQuizzes) { quiz in
                    QuizCardView(
                        quiz: quiz,
                        viewModel: QuizSolveViewModel(
                            quizId: Int(quiz.id) ?? -1,
                            deleteQuizUseCase: DIContainer.shared.makeDeleteQuizUseCase(),
                            fetchQuizDetailUseCase: DIContainer.shared.makeFetchQuizDetailUseCase()
                        ),
                        onDelete: { deletedQuiz in
                            viewModel.allQuizzes.removeAll { $0.id == deletedQuiz.id }
                        }
                    )
                    .padding(.horizontal)
                }
            )
        }
    }

    private var backButton: some View {
        Button(action: {
            DIContainer.shared.makeAppRouter().goBack()
        }) {
            HStack(spacing: 4) {
                Image(systemName: "chevron.left")
                Text("Back")
            }
            .foregroundColor(.black.opacity(0.7))
        }
    }

}
