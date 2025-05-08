//
//  GroupAvailabilityView.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/8/25.
//

import SwiftUI

struct GroupAvailabilityView: View {
    let group: ScheduleGroup
    let allSelectedSlots: [UUID: Set<TimeSlot>] // 사용자별 가능 슬롯
    let myUserId: UUID

    @State private var showEdit = false

    private let hours = Array(8...22)

    private var weekDates: [Date] {
        var dates: [Date] = []
        var current = group.startDate
        while current <= group.endDate {
            dates.append(current)
            current = Calendar.current.date(byAdding: .day, value: 1, to: current)!
        }
        return dates
    }

    private var slotCountMap: [TimeSlot: Int] {
        var counter: [TimeSlot: Int] = [:]
        for (_, slots) in allSelectedSlots {
            for slot in slots {
                counter[slot, default: 0] += 1
            }
        }
        return counter
    }

    var body: some View {
        VStack(spacing: 12) {
            Text(group.name)
                .font(.title2)

            Text(group.dateRangeString)
                .font(.caption)
                .foregroundColor(.gray)

            ScheduleSlotGrid(
                weekDates: weekDates,
                hours: hours,
                slotCountMap: slotCountMap
            )

            Button("내 시간 수정하기") {
                showEdit = true
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.3))
            .cornerRadius(10)
        }
        .padding()
        .sheet(isPresented: $showEdit) {
            GroupScheduleView(group: group)
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
                        .frame(width: cellWidth, height: 36)
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
                                            .frame(width: cellWidth, height: 14)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
        }
        .frame(height: 550)
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

// MARK: - Preview

#Preview {
    let calendar = Calendar.current
    let today = Date()
    let startOfWeek = calendar.date(byAdding: .day, value: -(calendar.component(.weekday, from: today) - 2), to: today)!
    let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!
    let weekDates = (0...6).compactMap { Calendar.current.date(byAdding: .day, value: $0, to: startOfWeek) }

    var mockSlots: [UUID: Set<TimeSlot>] = [:]
    for i in 0..<6 {
        let userId = UUID()
        var slots: Set<TimeSlot> = []
        for day in 0..<7 {
            for hour in 9...(9 + i) {
                if let date = Calendar.current.date(byAdding: .day, value: day, to: startOfWeek) {
                    slots.insert(TimeSlot(date: date, hour: hour, minute: 0))
                    slots.insert(TimeSlot(date: date, hour: hour, minute: 30))
                }
            }
        }
        mockSlots[userId] = slots
    }

    return GroupAvailabilityView(
        group: ScheduleGroup(name: "팀 회의 잡기", startDate: startOfWeek, endDate: endOfWeek),
        allSelectedSlots: mockSlots,
        myUserId: mockSlots.keys.first!
    )
}
