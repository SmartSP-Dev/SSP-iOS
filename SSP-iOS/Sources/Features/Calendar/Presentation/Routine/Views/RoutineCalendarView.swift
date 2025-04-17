//
//  RoutineCalendarView.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/16/25.
//

import SwiftUI

struct RoutineCalendarView: View {
    @ObservedObject var viewModel: RoutineViewModel
    @State private var weekOffset: Int = 0

    var body: some View {
        let weekDates = generateWeekDates(from: Date(), offset: weekOffset)

        VStack(spacing: 8) {
            // 상단 월 텍스트
            Text(monthText(for: weekDates.first ?? Date()))
                .font(.subheadline)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity, alignment: .center)

            // 주간 달력 뷰 (좌우 스와이프)
            TabView(selection: $weekOffset) {
                ForEach(-12...12, id: \.self) { offset in
                    weekRow(for: offset)
                        .tag(offset)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 60)
        }
    }

    // MARK: - 주간 뷰
    func weekRow(for offset: Int) -> some View {
        let dates = generateWeekDates(from: Date(), offset: offset)

        return HStack(spacing: 8) {
            ForEach(dates, id: \.self) { date in
                VStack {
                    Text(weekdayFormatter.string(from: date))
                    Text(dayFormatter.string(from: date))

                    Circle()
                        .fill(completionColor(for: date))
                        .frame(width: 8, height: 8)
                }
                .onTapGesture {
                    viewModel.selectedDate = date
                }
                .background(
                    Circle()
                        .fill(Color.blue.opacity(viewModel.selectedDate.isSameDay(as: date) ? 0.2 : 0))
                )
            }
        }
        .padding(.horizontal)
    }

    // MARK: - 월 텍스트
    private func monthText(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월"
        return formatter.string(from: date)
    }

    // MARK: - 주간 날짜 생성
    private func generateWeekDates(from base: Date, offset: Int) -> [Date] {
        let calendar = Calendar.current
        guard let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: base)?.start else { return [] }
        let adjustedStart = calendar.date(byAdding: .weekOfYear, value: offset, to: startOfWeek)!

        return (0..<7).compactMap {
            calendar.date(byAdding: .day, value: $0, to: adjustedStart)
        }
    }

    // MARK: - 달성도 색상
    private func completionColor(for date: Date) -> Color {
        let states = viewModel.repository.fetchCheckStates(for: date)
        guard !states.isEmpty else { return .gray.opacity(0.2) }

        let checkedCount = states.values.filter { $0 }.count
        let ratio = Double(checkedCount) / Double(states.count)

        switch ratio {
        case 1.0:
            return .blue
        case 0.5..<1.0:
            return .blue.opacity(0.5)
        case 0..<0.5:
            return .blue.opacity(0.2)
        default:
            return .gray.opacity(0.1)
        }
    }

    private let dayFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "d"
        return f
    }()

    private let weekdayFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "EEE"
        return f
    }()
}
