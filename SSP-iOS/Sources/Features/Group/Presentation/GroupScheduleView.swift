//
//  GroupScheduleView.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/5/25.
//

import SwiftUI

struct TimeSlot: Hashable {
    let day: Date
    let hour: Int
}

struct GroupScheduleView: View {
    let group: ScheduleGroup
    @State private var selectedSlots: Set<TimeSlot> = []

    @GestureState private var isDragging = false
    @State private var dragLocation: CGPoint? = nil
    @State private var isErasing: Bool? = nil
    @State private var slotFrames: [TimeSlot: CGRect] = [:]

    private let hours = Array(8...22)

    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ko_KR")
        df.dateFormat = "M/d"
        return df
    }()

    private let weekdayFormatter: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ko_KR")
        df.dateFormat = "E"
        return df
    }()

    private var weekDates: [Date] {
        var dates: [Date] = []
        var current = group.startDate
        while current <= group.endDate {
            dates.append(current)
            current = Calendar.current.date(byAdding: .day, value: 1, to: current)!
        }
        return dates
    }

    var body: some View {
        VStack(spacing: 8) {
            Text(group.name)
                .font(.title2)

            Text(group.dateRangeString)
                .font(.caption)
                .foregroundColor(.gray)

            GeometryReader { geometry in
                let totalWidth = geometry.size.width
                let timeLabelWidth: CGFloat = 36
                let spacing: CGFloat = 1
                let columnCount = weekDates.count
                let totalSpacing = spacing * CGFloat(columnCount - 1)
                let cellWidth = (totalWidth - timeLabelWidth - totalSpacing) / CGFloat(columnCount)

                LazyVStack(spacing: 1) {
                    // Header
                    HStack(spacing: spacing) {
                        Text("")
                            .frame(width: timeLabelWidth)

                        ForEach(weekDates, id: \.self) { date in
                            VStack {
                                Text(weekdayFormatter.string(from: date))
                                    .font(.caption)
                                Text(dateFormatter.string(from: date))
                                    .font(.caption2)
                            }
                            .frame(width: cellWidth, height: 36)
                            .background(Color.gray.opacity(0.2))
                        }
                    }

                    // Time grid
                    ForEach(hours, id: \.self) { hour in
                        HStack(spacing: spacing) {
                            Text("\(hour)시")
                                .font(.caption2)
                                .frame(width: timeLabelWidth, height: 32)
                                .background(Color.gray.opacity(0.15))

                            ForEach(weekDates, id: \.self) { date in
                                let slot = TimeSlot(day: date, hour: hour)

                                Rectangle()
                                    .fill(selectedSlots.contains(slot) ? Color.blue.opacity(0.7) : Color.gray.opacity(0.1))
                                    .frame(width: cellWidth, height: 32)
                                    .background(
                                        GeometryReader { geo in
                                            Color.clear
                                                .onAppear {
                                                    let frame = geo.frame(in: .named("GridArea"))
                                                    slotFrames[slot] = frame
                                                }
                                        }
                                    )
                                    .onTapGesture {
                                        toggle(slot)
                                    }
                            }
                        }
                    }
                }
                .coordinateSpace(name: "GridArea")
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .updating($isDragging) { _, isDragging, _ in
                            isDragging = true
                        }
                        .onChanged { value in
                            dragLocation = value.location

                            for (slot, frame) in slotFrames {
                                if frame.contains(value.location) {
                                    if isErasing == nil {
                                        // 드래그 방향 결정
                                        isErasing = selectedSlots.contains(slot)
                                    }

                                    if isErasing == true {
                                        selectedSlots.remove(slot)
                                    } else {
                                        selectedSlots.insert(slot)
                                    }
                                }
                            }
                        }
                        .onEnded { _ in
                            dragLocation = nil
                            isErasing = nil
                        }
                )
            }
            .frame(height: 550)

            Button("시간 저장하기") {
                print("선택된 시간: \(selectedSlots)")
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding(.horizontal, 10)
        .navigationTitle("시간 선택")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func toggle(_ slot: TimeSlot) {
        if selectedSlots.contains(slot) {
            selectedSlots.remove(slot)
        } else {
            selectedSlots.insert(slot)
        }
    }
}

// MARK: - Preview

#Preview {
    let calendar = Calendar.current
    let today = Date()
    let startOfWeek = calendar.date(byAdding: .day, value: -(calendar.component(.weekday, from: today) - 2), to: today)!
    let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!

    return NavigationView {
        GroupScheduleView(group: ScheduleGroup(
            name: "스터디 약속",
            startDate: startOfWeek,
            endDate: endOfWeek
        ))
    }
}
