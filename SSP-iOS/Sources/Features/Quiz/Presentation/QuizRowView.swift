//
//  QuizRowView.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/21/25.
//

import SwiftUI

struct QuizRowView: View {
    let quiz: Quiz

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(quiz.title)
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .lineLimit(1)

                Text(formattedDate(quiz.createdAt))
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Spacer()

            if quiz.isReviewed {
                Text("완료")
                    .font(.caption2)
                    .foregroundColor(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.gray)
                    .cornerRadius(4)
            } else {
                Text("복습 필요")
                    .font(.caption2)
                    .foregroundColor(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.black)
                    .cornerRadius(4)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal)
        .background(Color.white)
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}


#Preview {
    VStack(spacing: 0) {
        QuizRowView(quiz: Quiz(
            id: "1",
            title: "운영체제 기말 대비",
            keyword: "프로세스",
            type: .multipleChoice,
            createdAt: Date(),
            isReviewed: false,
            questionCount: 5
        ))

        Divider()

        QuizRowView(quiz: Quiz(
            id: "2",
            title: "데이터베이스 퀴즈",
            keyword: "트랜잭션",
            type: .ox,
            createdAt: Date(),
            isReviewed: true,
            questionCount: 3
        ))
    }
    .background(Color.gray.opacity(0.1))
}
