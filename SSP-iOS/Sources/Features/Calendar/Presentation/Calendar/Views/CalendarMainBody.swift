//
//  CalendarMainBody.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/16/25.
//

import SwiftUI

struct CalendarMainBody: View {
    @ObservedObject var viewModel: CalendarViewModel
    @GestureState private var dragOffset: CGFloat = 0

    var body: some View {
        VStack(spacing: 15) {
            weekdayHeader
            dayGrid

            if let selectedDate = viewModel.selectedDate {
                eventList(for: selectedDate)
            }

            Spacer(minLength: 40)
        }
        .padding(.top, 8)
    }

    private var weekdayHeader: some View {
        let weekdaySymbols = Calendar.current.shortStandaloneWeekdaySymbols
        return HStack(spacing: 4) {
            ForEach(weekdaySymbols, id: \.self) { symbol in
                Text(symbol)
                    .font(.PretendardMedium16)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(Color.black.opacity(0.7))
            }
        }
        .padding(.horizontal, 2)
    }

    private var dayGrid: some View {
        LazyVStack(spacing: 0) {
            ForEach(0..<viewModel.daysInMonth.chunked(into: 7).count, id: \.self) { weekIndex in
                let week = viewModel.daysInMonth.chunked(into: 7)[weekIndex]
                
                HStack(spacing: 2) {
                    ForEach(0..<week.count, id: \.self) { dayIndex in
                        let date = week[dayIndex]
                        
                        if Calendar.current.isDate(date, equalTo: Date.distantPast, toGranularity: .day) {
                            Color.clear.frame(height: 80).frame(maxWidth: .infinity)
                        } else {
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

                Rectangle()
                    .fill(Color.black.opacity(0.15))
                    .frame(height: 1)
                    .padding(.horizontal, 4)
            }
        }
    }

    @ViewBuilder
    private func eventList(for date: Date) -> some View {
        let events = viewModel.events[date.onlyDate] ?? []

        VStack(alignment: .leading, spacing: 8) {
            /// 날짜
            Text(date.formattedFullDateKorean())
                .font(.headline)
                .foregroundStyle(Color.black)
                .padding(.horizontal)

            /// 일정
            if events.isEmpty {
                Text("등록된 일정이 없습니다.")
                    .foregroundColor(.gray)
                    .padding(.horizontal)
            } else {
                List {
                    ForEach(events, id: \.id) { event in
                        EventRowView(event: event, viewModel: viewModel)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets())
                            .padding(.vertical, 4)
                    }
                    
                }
                .listStyle(.plain)
                .frame(minHeight: CGFloat(events.count) * 80)
            }
        }
        .padding(.top, 10)

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

