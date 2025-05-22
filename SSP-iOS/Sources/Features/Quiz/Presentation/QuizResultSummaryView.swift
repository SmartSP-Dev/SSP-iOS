//
//  QuizResultSummaryView.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/23/25.
//

import SwiftUI

struct QuizResultSummaryView: View {
    let result: SubmitQuizResponse

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("퀴즈 결과")
                    .font(.title2.bold())
                    .padding(.bottom, 8)

                HStack {
                    Text("총 문항 수: \(result.totalQuestions)")
                    Spacer()
                    Text("맞힌 개수: \(result.correctAnswers)")
                }
                .font(.subheadline)
                .foregroundColor(.gray)

                Divider()

                ForEach(result.questionResults.sorted(by: { $0.quizNumber < $1.quizNumber }), id: \.quizNumber) { r in
                    QuizResultCard(result: r)
                }

            }
            .padding()
        }
        .navigationTitle("퀴즈 결과")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct QuizResultCard: View {
    let result: SubmitQuizResponse.QuestionResult

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Q\(result.quizNumber). \(result.questionTitle)")
                .font(.headline)
                .fixedSize(horizontal: false, vertical: true)

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("내 답변:")
                        .fontWeight(.semibold)
                    Text(result.userAnswer)
                }
                HStack {
                    Text("정답:")
                        .fontWeight(.semibold)
                    Text(result.correctAnswer)
                }
            }
            .font(.subheadline)

            HStack {
                Image(systemName: result.correct ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundColor(result.correct ? .green : .red)
                Text(result.correct ? "정답" : "오답")
                    .foregroundColor(result.correct ? .green : .red)
                    .fontWeight(.semibold)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}
