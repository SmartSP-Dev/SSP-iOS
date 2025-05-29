//
//  SlotGridView.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/8/25.
//

import SwiftUI

struct SlotGridView: View {
    let weekDates: [Date]
    let hours: [Int]
    let selectedSlots: Set<TimeSlot>
    let busyFromSchedule: Set<TimeSlot>
    let busyFromEvent: Set<TimeSlot>
    let onToggle: (TimeSlot) -> Void

    @GestureState private var isDragging = false
    @State private var dragLocation: CGPoint? = nil
    @State private var isErasing: Bool? = nil
    @State private var slotFrames: [TimeSlot: CGRect] = [:]

    var body: some View {
        GeometryReader { geometry in
            let totalWidth = geometry.size.width
            let timeLabelWidth: CGFloat = 36
            let spacing: CGFloat = 1
            let columnCount = max(weekDates.count, 1)
            let totalSpacing = spacing * CGFloat(columnCount - 1)
            let safeColumnCount = max(columnCount, 1)
            let cellWidth = max(1, (totalWidth - timeLabelWidth - totalSpacing) / CGFloat(safeColumnCount))
            
            LazyVStack(spacing: 1) {
                // Header
                HStack(spacing: spacing) {
                    Text("")
                        .frame(width: timeLabelWidth)

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

                // Time grid split by 30 minutes
                ForEach(hours, id: \.self) { hour in
                    HStack(spacing: spacing) {
                        Text("\(hour)시")
                            .font(.caption2)
                            .frame(width: timeLabelWidth, height: 32)
                            .background(Color.gray.opacity(0.15))

                        VStack(spacing: 1) {
                            ForEach([0, 30], id: \.self) { minute in
                                HStack(spacing: spacing) {
                                    ForEach(weekDates, id: \.self) { date in
                                        let slot = TimeSlot(date: date, hour: hour, minute: minute)
                                        Rectangle()
                                            .fill(color(for: slot))
                                            .frame(width: max(cellWidth, 1), height: 16)
                                            .background(
                                                GeometryReader { geo in
                                                    Color.clear
                                                        .onChange(of: geo.size) {
                                                            let frame = geo.frame(in: .named("GridArea"))
                                                            guard frame.width.isFinite, frame.height.isFinite, frame.width >= 0, frame.height >= 0 else { return }
                                                            slotFrames[slot] = frame
                                                        }
                                                }
                                            )
                                            .onTapGesture {
                                                onToggle(slot)
                                            }
                                    }
                                }
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
                                    isErasing = selectedSlots.contains(slot)
                                }

                                if isErasing == true {
                                    if selectedSlots.contains(slot) {
                                        onToggle(slot)
                                    }
                                } else {
                                    if !selectedSlots.contains(slot) {
                                        onToggle(slot)
                                    }
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
    }

    private func color(for slot: TimeSlot) -> Color {
        if selectedSlots.contains(slot) {
            return .black.opacity(0.7)
        } else if busyFromEvent.contains(slot) {
            return .pink.opacity(0.2)
        } else if busyFromSchedule.contains(slot) {
            return .orange.opacity(0.2)
        } else {
            return .gray.opacity(0.1)
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

    return SlotGridView(
        weekDates: weekDates,
        hours: Array(8...22),
        selectedSlots: [],
        busyFromSchedule: [],
        busyFromEvent: [],
        onToggle: { _ in }
    )
}
