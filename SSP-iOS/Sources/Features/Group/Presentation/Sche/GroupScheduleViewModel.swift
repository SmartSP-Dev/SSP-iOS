//
//  GroupScheduleViewModel.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/8/25.
//

import Foundation
import SwiftUI
import EventKit

final class GroupScheduleViewModel: ObservableObject {
    // MARK: - Input
    let group: ScheduleGroup

    // MARK: - Output
    @Published var selectedSlots: Set<TimeSlot> = []
    @Published var busyFromSchedule: Set<TimeSlot> = []
    @Published var busyFromEvent: Set<TimeSlot> = []

    private let eventStore = EKEventStore()

    // MARK: - Init
    init(group: ScheduleGroup) {
        self.group = group
        fetchCalendarEvents()
    }

    // MARK: - API

//    func loadTimeTable(from data: [WeekScheduleDTO]) {
//        var result: Set<TimeSlot> = []
//
//        for daySchedule in data {
//            guard let weekDayIndex = Self.weekdayIndex(for: daySchedule.timePoint),
//                  let date = Calendar.current.date(byAdding: .day, value: weekDayIndex, to: group.startDate) else { continue }
//
//            for subject in daySchedule.subjects {
//                for timeStr in subject.times {
//                    if let hour = Self.extractHour(from: timeStr) {
//                        let slot = TimeSlot(date: date, hour: hour)
//                        result.insert(slot)
//                    }
//                }
//            }
//        }
//
//        busyFromSchedule = result
//    }

    func toggle(_ slot: TimeSlot) {
        if selectedSlots.contains(slot) {
            selectedSlots.remove(slot)
        } else {
            selectedSlots.insert(slot)
        }
    }

    // MARK: - EventKit (Calendar)

    private func fetchCalendarEvents() {
        if #available(iOS 17, *) {
            eventStore.requestFullAccessToEvents(completion: { granted, _ in
                self.handleAccess(granted: granted)
            })
        } else {
            eventStore.requestAccess(to: .event) { granted, _ in
                self.handleAccess(granted: granted)
            }
        }
    }

    private func handleAccess(granted: Bool) {
        guard granted else { return }

        let predicate = self.eventStore.predicateForEvents(
            withStart: self.group.startDate,
            end: self.group.endDate,
            calendars: nil
        )

        let events = self.eventStore.events(matching: predicate)
        self.debugLog(events: events)
        let slots = events.flatMap { Self.convertEventToSlots(event: $0) }

        DispatchQueue.main.async {
            self.busyFromEvent = Set(slots)
        }
    }

    private static func convertEventToSlots(event: EKEvent) -> [TimeSlot] {
        var slots: [TimeSlot] = []

        guard var current = event.startDate, let end = event.endDate else {
            return []
        }

        while current < end {
            let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: current)

            let hour = components.hour ?? 0
            let minute = (components.minute ?? 0) < 30 ? 0 : 30

            let dayOnly = Calendar.current.startOfDay(for: current)
            let slot = TimeSlot(date: dayOnly, hour: hour, minute: minute)
            slots.append(slot)

            guard let next = Calendar.current.date(byAdding: .minute, value: 30, to: current) else {
                break
            }

            current = next
        }

        return slots
    }

    private func debugLog(events: [EKEvent]) {
        print("불러온 캘린더 이벤트 수: \(events.count)")
        for event in events {
            print("[\(event.title ?? "제목없음")] \(event.startDate ?? Date()) ~ \(event.endDate ?? Date())")
        }
    }

    // MARK: - Helpers

    private static func extractHour(from timeStr: String) -> Int? {
        let components = timeStr.split(separator: ":")
        guard let hour = components.first, let hourInt = Int(hour) else { return nil }
        return hourInt
    }

    private static func weekdayIndex(for timePoint: String) -> Int? {
        let days = ["월": 0, "화": 1, "수": 2, "목": 3, "금": 4, "토": 5, "일": 6]
        return days[timePoint]
    }
}
