//
//  QuizCardView.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/21/25.
//

import SwiftUI

struct QuizCardView: View {
    let quiz: Quiz

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

            Text("문제 수: \(quiz.questionCount)")
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
                    // TODO: 복습 진입 액션
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


#Preview {
    VStack(spacing: 20) {
        QuizCardView(quiz: Quiz(
            id: "1",
            title: "운영체제 기말 대비",
            keyword: "프로세스",
            type: .multipleChoice,
            createdAt: Date(),
            isReviewed: false,
            questionCount: 5
        ))
        
        QuizCardView(quiz: Quiz(
            id: "2",
            title: "데이터베이스 퀴즈",
            keyword: "트랜잭션",
            type: .ox,
            createdAt: Date(),
            isReviewed: true,
            questionCount: 3
        ))
    }
    .padding()
    .background(Color.gray.opacity(0.2))
}
