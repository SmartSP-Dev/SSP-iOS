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

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("시간표 미리보기")
                    .font(.headline)
                Spacer()
                Button(action: onEdit) {
                    Text("수정")
                        .font(.subheadline)
                        .foregroundColor(.black)
                }
            }

            ForEach(schedules) { day in
                VStack(alignment: .leading, spacing: 8) {
                    Text(day.timePoint)
                        .font(.subheadline)
                        .fontWeight(.bold)

                    ForEach(day.subjects, id: \.subject) { subject in
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
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    TimetableCardView(
        schedules: ScheduleDay.sampleData,
        onEdit: {},
        timetableLink: "https://example.com"
    )
}
