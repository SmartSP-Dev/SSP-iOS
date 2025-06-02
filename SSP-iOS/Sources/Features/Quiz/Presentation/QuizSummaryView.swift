//
//  QuizSummaryView.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/21/25.
//

import SwiftUI

struct QuizSummaryView: View {
    let total: Int
    let reviewed: Int
    let pending: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("이번 주 퀴즈 요약")
                .font(.headline)
                .foregroundColor(.black.opacity(0.7))

            HStack(spacing: 16) {
                summaryItem(title: "총 퀴즈", value: total)
                summaryItem(title: "복습 완료", value: reviewed)
                summaryItem(title: "미복습", value: pending)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 1)
        .padding(.horizontal)
    }

    private func summaryItem(title: String, value: Int) -> some View {
        VStack(spacing: 4) {
            Text("\(value)")
                .font(.title2)
                .bold()
                .foregroundColor(.black.opacity(0.7))
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
    }
}


#Preview {
    QuizSummaryView(total: 5, reviewed: 3, pending: 2)
        .background(Color.gray.opacity(0.1))
}
