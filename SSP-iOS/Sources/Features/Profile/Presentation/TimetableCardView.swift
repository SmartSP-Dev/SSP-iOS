//
//  TimetableCardView.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/26/25.
//

import SwiftUI

struct TimetableCardView: View {
    let schedules: [ScheduleDay]
    var onEdit: () -> Void
    var timetableLink: String? // 조회용 링크
    let dayOrder: [String] = ["월", "화", "수", "목", "금", "토", "일"]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("시간표 미리보기")
                    .font(.headline)
                Spacer()
                Button(action: onEdit) {
                    Text("수정")
                        .font(.subheadline)
                        .foregroundColor(.black.opacity(0.7))
                }
            }

            if schedules.isEmpty {
                Text("시간표를 입력해주세요!")
                    .foregroundColor(.gray)
                    .font(.caption)
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(Color.white)
                    .cornerRadius(12)
                    .padding(.top, 8)
            } else {
                ForEach(
                    schedules.sorted { lhs, rhs in
                        let lhsIndex = dayOrder.firstIndex(of: lhs.timePoint) ?? 99
                        let rhsIndex = dayOrder.firstIndex(of: rhs.timePoint) ?? 99
                        return lhsIndex < rhsIndex
                    }
                ) { day in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(day.timePoint)
                            .font(.subheadline)
                            .fontWeight(.bold)

                        ForEach(day.subjects.sorted(by: { $0.times.first ?? "" < $1.times.first ?? "" }), id: \ .subject) { subject in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(subject.titleLine)
                                    .font(.body)
                                    .fontWeight(.semibold)

                                HStack {
                                    Text(subject.timeRange)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    Spacer()
                                    Text(subject.locationLine)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(8)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.05), radius: 1, x: 0, y: 1)
                        }
                    }
                    .padding(.bottom, 6)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    TimetableCardView(
        schedules: [],
        onEdit: {},
        timetableLink: "https://example.com"
    )
}
