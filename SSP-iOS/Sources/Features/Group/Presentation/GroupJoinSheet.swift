//
//  GroupJoinSheet.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/5/25.
//

import SwiftUI

struct GroupJoinSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var groupCode: String = ""

    let onJoin: (ScheduleGroup) -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("그룹 코드를 입력해주세요!")
                .font(.headline)

            TextField("코드를 입력하세요", text: $groupCode)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Button("확인") {
                // 임시: 오늘 기준 주간 날짜로 생성
                let calendar = Calendar.current
                let today = Date()
                let weekday = calendar.component(.weekday, from: today)
                let startOfWeek = calendar.date(byAdding: .day, value: -(weekday - 2), to: today)!
                let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!

                let joinedGroup = ScheduleGroup(
                    name: "참여한 그룹 (\(groupCode))",
                    startDate: startOfWeek,
                    endDate: endOfWeek
                )

                onJoin(joinedGroup)
                dismiss()
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
        }
        .padding()
    }
}

// MARK: - Preview

#Preview {
    GroupJoinSheet { group in
        print("참여 그룹: \(group.name) \(group.dateRangeString)")
    }
}
