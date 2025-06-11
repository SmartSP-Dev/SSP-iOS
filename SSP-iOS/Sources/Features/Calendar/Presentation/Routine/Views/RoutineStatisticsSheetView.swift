//
//  RoutineStatisticsSheetView.swift
//  SSP-iOS
//
//  Created by 황상환 on 6/9/25.
//

import SwiftUI

struct RoutineStatisticsSheetView: View {
    let summaryList: [RoutineSummaryDTO]

    private var successRate: Double {
        guard !summaryList.isEmpty else { return 0 }
        let successCount = summaryList.filter { $0.achieved }.count
        return Double(successCount) / Double(summaryList.count)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                Text("루틴 통계")
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                
                Text("루틴은 일일 기준 80% 이상일 경우만 성공으로 판단해요!")
                    .font(.subheadline)
                
                ProgressView(value: successRate)
                    .progressViewStyle(.linear)
                    .padding(.horizontal)

                Text("달성률 \(Int(successRate * 100))%")
                    .font(.headline)

                List(summaryList, id: \.date) { item in
                    HStack {
                        Text(item.date)
                            .font(.body)
                        Spacer()
                        Image(systemName: item.achieved ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundStyle(item.achieved ? .green : .red)
                    }
                }
                .listStyle(.plain)
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("닫기") {
                        dismiss()
                    }
                }
            }
        }
    }

    @Environment(\.dismiss) private var dismiss
}

#Preview {
    RoutineStatisticsSheetView(summaryList: [
        RoutineSummaryDTO(date: "2025-06-01", achieved: true),
        RoutineSummaryDTO(date: "2025-06-02", achieved: false),
        RoutineSummaryDTO(date: "2025-06-03", achieved: true)
    ])
}
