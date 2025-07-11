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

        VStack(spacing: 12) {
            // 상단 월 텍스트
            Text(monthText(for: weekDates.first ?? Date()))
                .font(.subheadline)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .center)

            // 주간 달력 뷰 (좌우 스와이프)
            TabView(selection: $weekOffset) {
                ForEach(-12...12, id: \.self) { offset in
                    weekRow(for: offset)
                        .tag(offset)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 80)
        }
        .padding(.top, 20)
    }

    // MARK: - 주간 뷰
    func weekRow(for offset: Int) -> some View {
        let dates = generateWeekDates(from: Date(), offset: offset)

        return HStack(spacing: 0) {
            ForEach(dates, id: \.self) { date in
                let isToday = viewModel.selectedDate.isSameDay(as: date)

                VStack(spacing: 6) {
                    Text(weekdayFormatter.string(from: date))
                        .font(.caption)
                        .foregroundColor(.gray)

                    Text(dayFormatter.string(from: date))
                        .font(.headline)
                        .foregroundColor(isToday ? .white : .primary)
                        .frame(width: 36, height: 36)
                        .background(
                            Circle()
                                .fill(isToday ? Color.black.opacity(0.7) : Color.clear)
                        )

                    Circle()
                        .fill(completionColor(for: date))
                        .frame(width: 6, height: 6)
                }
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.selectedDate = date
                }
            }
        }
        .padding(.horizontal, 12)
    }

    // MARK: - 유틸
    private func monthText(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월"
        return formatter.string(from: date)
    }

    private func generateWeekDates(from base: Date, offset: Int) -> [Date] {
        let calendar = Calendar.current
        guard let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: base)?.start else { return [] }
        let adjustedStart = calendar.date(byAdding: .weekOfYear, value: offset, to: startOfWeek)!

        return (0..<7).compactMap {
            calendar.date(byAdding: .day, value: $0, to: adjustedStart)
        }
    }

    private func completionColor(for date: Date) -> Color {
        let calendar = Calendar.current
        let routinesOnDate = viewModel.routines.filter {
            calendar.isDate($0.startDate, inSameDayAs: date)
        }

        guard !routinesOnDate.isEmpty else { return .gray.opacity(0.2) }
        
        let checkedCount = routinesOnDate.filter { $0.isCompleted }.count
        let ratio = Double(checkedCount) / Double(routinesOnDate.count)

        switch ratio {
        case 1.0:
            return .black
        case 0.5..<1.0:
            return .black.opacity(0.5)
        case 0..<0.5:
            return .black.opacity(0.2)
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

//#Preview {
//    RoutineCalendarView(viewModel: RoutineViewModel(repository: DummyRoutineRepository()))
//}
