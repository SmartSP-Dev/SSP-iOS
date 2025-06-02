//
//  QuizResultView.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/25/25.
//

import SwiftUI

struct QuizResultView: View {
    @StateObject private var viewModel: QuizResultViewModel

    init(quizId: Int) {
        _viewModel = StateObject(wrappedValue: QuizResultViewModel(quizId: quizId))
    }

    var body: some View {
        Group {
            if let result = viewModel.result {
                QuizResultSummaryView(result: result)
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            } else {
                ProgressView("결과 불러오는 중...")
                    .padding()
            }
        }
        .task {
            await viewModel.fetchResult()
        }
        .navigationTitle("퀴즈 결과")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    DIContainer.shared.makeAppRouter().goBack()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black.opacity(0.7))
                    Text("Back")
                        .foregroundColor(.black.opacity(0.7))
                }
            }
        }
    }
}
