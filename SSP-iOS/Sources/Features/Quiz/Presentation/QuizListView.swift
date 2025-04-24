//
//  QuizListView.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/22/25.
//

import SwiftUI

struct QuizListView: View {
    @StateObject private var viewModel: QuizMainViewModel

    /// 메인액터 충돌 피하기 위해 DIContainer에서 뷰 외부에서 주입받도록 강제
    init(viewModel: QuizMainViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("전체 퀴즈 목록")
                    .font(.title2)
                    .bold()
                    .padding(.horizontal)

                if viewModel.allQuizzes.isEmpty {
                    Text("아직 생성된 퀴즈가 없어요.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    ForEach(viewModel.allQuizzes) { quiz in
                        QuizCardView(quiz: quiz)
                            .padding(.horizontal)
                    }
                }
            }
            .padding(.top)
        }
        .background(Color.white)
        .navigationTitle("내 퀴즈")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                await viewModel.fetchAll()
            }
        }
    }
}
