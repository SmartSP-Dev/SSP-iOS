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
                if !viewModel.reviewQuizzes.isEmpty {
                    QuizSummaryView(
                        total: viewModel.reviewQuizzes.count,
                        reviewed: viewModel.reviewQuizzes.filter { $0.isReviewed }.count,
                        pending: viewModel.reviewQuizzes.filter { !$0.isReviewed }.count
                    )
                }

                // 퀴즈 만들기 버튼
                Button(action: {
                    // TODO: 퀴즈 생성 모달 표시
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
                        // TODO: QuizListView로 이동
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
            }
        }
    }
}


// MARK: - Preview

#Preview {
    let dummyQuizzes: [Quiz] = [
        .init(id: "1", title: "운영체제 기말 대비", keyword: "프로세스", type: .multipleChoice, createdAt: Date(), isReviewed: false, questionCount: 5),
        .init(id: "2", title: "데이터베이스 퀴즈", keyword: "트랜잭션", type: .ox, createdAt: Date(), isReviewed: true, questionCount: 3)
    ]
    
    let viewModel = QuizMainViewModel(
        fetchAllQuizzesUseCase: DummyFetchAllQuizzesUseCase(result: dummyQuizzes),
        fetchReviewTargetUseCase: DummyFetchReviewTargetQuizzesUseCase(result: [dummyQuizzes[0]])
    )
    
    return QuizMainView(viewModel: viewModel)
}

// MARK: - Dummy UseCases for Preview

final class DummyFetchAllQuizzesUseCase: FetchAllQuizzesUseCase {
    private let result: [Quiz]
    init(result: [Quiz]) { self.result = result }
    func execute() async throws -> [Quiz] { result }
}

final class DummyFetchReviewTargetQuizzesUseCase: FetchReviewTargetQuizzesUseCase {
    private let result: [Quiz]
    init(result: [Quiz]) { self.result = result }
    func execute() async throws -> [Quiz] { result }
}
