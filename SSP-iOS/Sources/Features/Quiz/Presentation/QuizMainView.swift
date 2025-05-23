//
//  QuizMainView.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/21/25.
//

import SwiftUI

struct QuizMainView: View {
    @StateObject private var viewModel: QuizMainViewModel

    init(viewModel: QuizMainViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                // 퀴즈 복습 요약
                if let summary = viewModel.quizWeekSummary {
                    QuizSummaryView(
                        total: summary.total,
                        reviewed: summary.reviewed,
                        pending: summary.notReviewed
                    )
                }

                // 퀴즈 만들기 버튼
                Button(action: {
                    DIContainer.shared.makeAppRouter().navigate(to: .quizCreate)
                }) {
                    Text("퀴즈 만들기")
                        .font(.body.weight(.bold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        .cornerRadius(10)
                        .padding(.horizontal)
                }

                // 최근 퀴즈 목록 (5개)
                Text("내 퀴즈 목록")
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(.horizontal)

                VStack(spacing: 0) {
                    ForEach(viewModel.allQuizzes.prefix(5)) { quiz in
                        QuizRowView(quiz: quiz)
                        Divider().padding(.leading)
                    }

                    // 더보기 버튼
                    Button(action: {
                        DIContainer.shared.makeAppRouter().navigate(to: .quizList)
                    }) {
                        Text("더보기")
                            .font(.caption)
                            .foregroundColor(.black)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                    }
                    .background(Color.white)
                }
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 1)
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(Color.white.edgesIgnoringSafeArea(.all))
        .onAppear {
            Task {
                await viewModel.fetchAll()
                await viewModel.fetchReviewTarget()
                await viewModel.fetchQuizSummary()
            }
        }
    }
}
