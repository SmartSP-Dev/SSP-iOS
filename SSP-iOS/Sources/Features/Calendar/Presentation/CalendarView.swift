//
//  CalendarView.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/14/25.
//

import SwiftUI

/// 월간 달력을 보여주는 뷰
/// - 상단: 월 전환 버튼
/// - 중간: 요일 헤더
/// - 하단: 날짜 셀 그리드 (주 단위)
struct CalendarView: View {

    // ViewModel 주입 (DIContainer 사용 권장)
    @ObservedObject var viewModel: CalendarViewModel

    // 요일 기호 (일, 월, 화, ...)
    let weekdaySymbols = Calendar.current.shortStandaloneWeekdaySymbols

    var body: some View {
        VStack(spacing: 15) {
            monthHeader            // 상단 월 전환 헤더
            weekdayHeader          // 요일 헤더
            dayGrid                // 날짜 셀 그리드
            Spacer()
        }
        .padding(.top, 16)
    }

    // MARK: - 월 전환 헤더
    private var monthHeader: some View {
        HStack {
            Spacer()
            // 이전 달 이동
            Button(action: { viewModel.changeMonth(by: -1) }) {
                Image(systemName: "chevron.left")
                    .foregroundStyle(Color("mainColor800"))
            }
            Spacer()
            // 현재 선택된 월 표시
            Text(viewModel.currentMonth, formatter: monthFormatter)
                .font(.title2)
                .foregroundStyle(Color("mainColor800"))
                .fontWeight(.bold)
            Spacer()
            // 다음 달 이동
            Button(action: { viewModel.changeMonth(by: 1) }) {
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color("mainColor800"))
            }
            Spacer()
        }
    }

    // MARK: - 요일 헤더 (일, 월, ...)
    private var weekdayHeader: some View {
        HStack(spacing: 4) {
            ForEach(weekdaySymbols, id: \.self) { symbol in
                Text(symbol)
                    .font(.PretendardSemiBold16)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(Color("mainColor800"))
            }
        }
        .padding(.horizontal, 2)
    }

    // MARK: - 날짜 셀 그리드 (주 단위로 렌더링)
    private var dayGrid: some View {
        LazyVStack(spacing: 0) {
            ForEach(0..<viewModel.daysInMonth.chunked(into: 7).count, id: \.self) { weekIndex in
                let week = viewModel.daysInMonth.chunked(into: 7)[weekIndex]
                
                HStack(spacing: 2) {
                    ForEach(0..<week.count, id: \.self) { dayIndex in
                        let date = week[dayIndex]
                        
                        if Calendar.current.isDate(date, equalTo: Date.distantPast, toGranularity: .day) {
                            // 빈 칸 (해당 주에 날짜가 없는 셀)
                            Color.clear.frame(height: 80).frame(maxWidth: .infinity)
                        } else {
                            // 정상 날짜 셀
                            CalendarDayCellView(
                                date: date,
                                events: viewModel.events[date.onlyDate] ?? [],
                                isToday: Calendar.current.isDateInToday(date),
                                isSelected: viewModel.selectedDate == date
                            )
                            .onTapGesture {
                                viewModel.selectedDate = date
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                }
                .padding(.horizontal, 4)

                // 주 구분선
                Rectangle()
                    .fill(Color.black.opacity(0.15))
                    .frame(height: 1)
                    .padding(.horizontal, 4)
            }
        }
    }

    // MARK: - 월 텍스트 포맷터 ("2025년 4월")
    private var monthFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월"
        return formatter
    }
}

// MARK: - Array chunking (주 단위로 나누기)
extension Array {
    /// 배열을 지정된 크기로 분할하여 2차원 배열로 리턴
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}
