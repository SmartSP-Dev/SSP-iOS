//
//  MonthlySummarySectionView.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/18/25.
//

import SwiftUI

struct MonthlySummarySectionView: View {
    let daysStudied: Int
    let totalMinutes: Int
    let averageMinutes: Double
    let bestDay: String
    let bestDayMinutes: Int

    var body: some View {
        SectionView(
            title: "이번 달 학습량",
            showsButton: false,
            contentHeight: 150
        ) {
            VStack(alignment: .center, spacing: 15) {
                summaryRow(title: "총 학습 일수", value: "\(daysStudied)일")
                summaryRow(title: "총 공부 시간", value: "\(totalMinutes)분")
                summaryRow(title: "1일 평균", value: String(format: "%.1f분", averageMinutes))
                summaryRow(title: "최고 공부일", value: "\(bestDay)일 (\(bestDayMinutes)분)")
            }
        }
    }

    private func summaryRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .font(.subheadline.bold())
                .foregroundColor(.black.opacity(0.7))
        }
    }
}

#Preview("데이터 있음") {
    MonthlySummarySectionView(
        daysStudied: 17,
        totalMinutes: 980,
        averageMinutes: 57.6,
        bestDay: "4월 11일",
        bestDayMinutes: 125
    )
}

#Preview("데이터 없음") {
    MonthlySummarySectionView(
        daysStudied: 0,
        totalMinutes: 0,
        averageMinutes: 0.0,
        bestDay: "-",
        bestDayMinutes: 0
    )
}
