//
//  GroupAvailabilityView.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/8/25.
//

import SwiftUI

struct GroupAvailabilityView: View {
    @StateObject private var viewModel: GroupAvailabilityViewModel
    @State private var showEdit = false
    @State private var isEditingSchedule = false
    
    private let hours = Array(8...22)

    private var weekDates: [Date] {
        var dates: [Date] = []
        var current = viewModel.group.startDate
        while current <= viewModel.group.endDate {
            dates.append(current)
            current = Calendar.current.date(byAdding: .day, value: 1, to: current)!
        }
        return dates
    }

    init(group: ScheduleGroup) {
        _viewModel = StateObject(
            wrappedValue: GroupAvailabilityViewModel(
                group: group,
                groupRepository: DIContainer.shared.exposedGroupRepository
            )
        )
    }
    
    var body: some View {
        VStack(spacing: 12) {
            Text(viewModel.group.name)
                .font(.title2)

            Text(viewModel.group.dateRangeString)
                .font(.caption)
                .foregroundColor(.gray)

            ScheduleSlotGrid(
                weekDates: weekDates,
                hours: Array(8...22),
                slotCountMap: viewModel.slotCountMap
            )

            Spacer()
            
            Button("내 시간 수정하기") {
                isEditingSchedule = true
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.3))
            .cornerRadius(10)
        }
        .padding()
        .navigationDestination(isPresented: $isEditingSchedule) {
            GroupScheduleView(group: viewModel.group)
        }
        .onAppear {
            Task {
                await viewModel.fetchTimetable()
            }
        }
    }
}

// MARK: - Subview

struct ScheduleSlotGrid: View {
    let weekDates: [Date]
    let hours: [Int]
    let slotCountMap: [TimeSlot: Int]

    var body: some View {
        GeometryReader { geometry in
            let totalWidth = geometry.size.width
            let timeLabelWidth: CGFloat = 36
            let spacing: CGFloat = 1
            let columnCount = weekDates.count
            let totalSpacing = spacing * CGFloat(columnCount - 1)
            let cellWidth = (totalWidth - timeLabelWidth - totalSpacing) / CGFloat(columnCount)

            LazyVStack(spacing: 1) {
                HStack(spacing: spacing) {
                    Text("").frame(width: timeLabelWidth)
                    ForEach(weekDates, id: \.self) { date in
                        VStack {
                            Text(Self.weekdayFormatter.string(from: date))
                                .font(.caption)
                            Text(Self.dateFormatter.string(from: date))
                                .font(.caption2)
                        }
                        .frame(width: max(1, cellWidth), height: 36)
                        .background(Color.gray.opacity(0.2))
                    }
                }

                ForEach(hours, id: \.self) { hour in
                    HStack(spacing: spacing) {
                        Text("\(hour)시")
                            .font(.caption2)
                            .frame(width: timeLabelWidth, height: 28)
                            .background(Color.gray.opacity(0.15))

                        VStack(spacing: 1) {
                            ForEach([0, 30], id: \.self) { minute in
                                HStack(spacing: spacing) {
                                    ForEach(weekDates, id: \.self) { date in
                                        let slot = TimeSlot(date: date, hour: hour, minute: minute)
                                        Rectangle()
                                            .fill(grayFor(count: slotCountMap[slot] ?? 0))
                                            .frame(width: max(1, cellWidth), height: 14)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
        }
        .frame(height: 500)
    }

    private func grayFor(count: Int) -> Color {
        switch count {
        case 5...: return Color.gray.opacity(0.9)
        case 4: return Color.gray.opacity(0.75)
        case 3: return Color.gray.opacity(0.6)
        case 2: return Color.gray.opacity(0.4)
        case 1: return Color.gray.opacity(0.25)
        default: return Color.gray.opacity(0.05)
        }
    }

    private static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ko_KR")
        df.dateFormat = "M/d"
        return df
    }()

    private static let weekdayFormatter: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ko_KR")
        df.dateFormat = "E"
        return df
    }()
}

