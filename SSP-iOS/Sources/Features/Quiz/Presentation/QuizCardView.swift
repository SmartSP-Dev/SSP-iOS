//
//  QuizCardView.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/21/25.
//

import SwiftUI

struct QuizCardView: View {
    let quiz: Quiz
    let viewModel: QuizSolveViewModel
    let onDelete: (Quiz) -> Void

    @State private var isDeleting = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(quiz.title)
                    .font(.headline)
                    .foregroundColor(.black)
                    .lineLimit(2)
                Spacer()
                Text(quiz.type.rawValue)
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Text("키워드: \(quiz.keyword)")
                .font(.subheadline)
                .foregroundColor(.black)

            Text("생성일: \(formattedDate(quiz.createdAt))")
                .font(.caption2)
                .foregroundColor(.gray)

            Spacer()

            if quiz.isReviewed {
                Text("복습 완료")
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.vertical, 6)
                    .frame(maxWidth: .infinity)
                    .background(Color.gray)
                    .cornerRadius(8)
            } else {
                Button(action: {
                    if let intId = Int(quiz.id) {
                        DIContainer.shared.makeAppRouter().navigate(to: .quizSolve(quizId: intId))
                    }
                }) {
                    Text("복습하기")
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(.vertical, 6)
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .cornerRadius(8)
                }
            }

            // 삭제 버튼
            Button(action: {
                isDeleting = true
                Task {
                    isDeleting = true
                    let success = await viewModel.deleteQuiz()
                    isDeleting = false
                    if success {
                        onDelete(quiz)
                    }
                }
            }) {
                HStack {
                    Image(systemName: "trash")
                    Text(isDeleting ? "삭제 중..." : "삭제")
                }
                .font(.caption)
                .foregroundColor(.red)
                .padding(.vertical, 4)
                .frame(maxWidth: .infinity)
                .background(Color.red.opacity(0.1))
                .cornerRadius(8)
            }
            .disabled(isDeleting)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}
