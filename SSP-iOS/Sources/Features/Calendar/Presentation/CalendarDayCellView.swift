//
//  CalendarDayCellView.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/15/25.
//

import SwiftUI

/// 달력의 하루(day) 셀을 표현하는 뷰
/// - 날짜 숫자 + 일정 최대 2개 + 초과 일정 표시
struct CalendarDayCellView: View {
    
    // MARK: - Input Properties
    let date: Date                      // 셀의 날짜
    let events: [CalendarEvent]        // 해당 날짜의 일정 목록
    let isToday: Bool                  // 오늘인지 여부 (강조 스타일)
    let isSelected: Bool               // 선택된 셀인지 여부 (선택 시 원형 배경)

    // 일정은 최대 2개까지만 표시 (나머지는 +N개로 표현)
    private let maxEventCount = 2

    var body: some View {
        VStack(spacing: 4) {
            // MARK: - 날짜 숫자 표시 영역
            ZStack {
                if isSelected {
                    // 선택된 날짜 배경 (얇은 파란 원)
                    Circle()
                        .fill(Color.blue.opacity(0.3))
                        .frame(width: 28, height: 28)
                }

                // 날짜 숫자 (1, 2, ..., 31)
                Text("\(Calendar.current.component(.day, from: date))")
                    .font(.PretendardBold16)
                    .foregroundColor(isToday ? .red : Color("mainColor800"))
            }
            .frame(height: 28)

            // MARK: - 일정 목록 표시 영역
            eventListView(events)
                .frame(maxHeight: .infinity, alignment: .top)
        }
        .padding(4)
        .frame(height: 85, alignment: .top)
    }

    // MARK: - 일정 리스트 뷰 분리 (추상화)
    /// 최대 2개의 일정을 표시하고, 초과 시 "+N개" 텍스트 표시
    @ViewBuilder
    private func eventListView(_ events: [CalendarEvent]) -> some View {
        VStack(spacing: 2) {
            // 최대 2개의 일정만 표시
            ForEach(events.prefix(maxEventCount), id: \.id) { event in
                Text(event.title)
                    .font(.caption2)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .foregroundColor(.white)
                    .padding(.horizontal, 4)
                    .background(event.color)
                    .cornerRadius(4)
            }

            // 일정이 3개 이상일 경우 "+N개"로 추가 표시
            if events.count > maxEventCount {
                Text("+\(events.count - maxEventCount)개")
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
        }
    }
}
