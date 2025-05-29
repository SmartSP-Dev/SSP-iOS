//
//  GroupScheduleViewModel.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/8/25.
//

import Foundation
import SwiftUI

// 시간표 데이터(JSON 형식)를 loadTimeTable()로 받아 busyFromSchedule로 변환
// EventKit에서 받아온 일정은 loadEventKitSlots()를 통해 busyFromEvent로 저장
// selectedSlots는 유저의 선택값이며, 드래그/터치로 토글 가능

final class GroupScheduleViewModel: ObservableObject {
    // MARK: - Input
    let group: ScheduleGroup

    // MARK: - Output
    @Published var selectedSlots: Set<TimeSlot> = []
    @Published var busyFromSchedule: Set<TimeSlot> = []
    @Published var busyFromEvent: Set<TimeSlot> = []

    // MARK: - Init
    init(group: ScheduleGroup) {
        self.group = group
    }

    // MARK: - API
    func loadTimeTable(from data: [WeekScheduleDTO]) {
        var result: Set<TimeSlot> = []

        for daySchedule in data {
            guard let weekDayIndex = Self.weekdayIndex(for: daySchedule.timePoint),
                  let date = Calendar.current.date(byAdding: .day, value: weekDayIndex, to: group.startDate) else { continue }

            for subject in daySchedule.subjects {
                for timeStr in subject.times {
                    if let hour = Self.extractHour(from: timeStr) {
                        let slot = TimeSlot(date: date, hour: hour)
                        result.insert(slot)
                    }
                }
            }
        }

        busyFromSchedule = result
    }

    func loadEventKitSlots(_ slots: Set<TimeSlot>) {
        busyFromEvent = slots
    }

    func toggle(_ slot: TimeSlot) {
        if selectedSlots.contains(slot) {
            selectedSlots.remove(slot)
        } else {
            selectedSlots.insert(slot)
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

// MARK: - Mock DTO

struct WeekScheduleDTO: Decodable {
    let timePoint: String // 요일: "화"
    let subjects: [SubjectsDTO]
}

struct SubjectsDTO: Decodable {
    let subject: String
    let times: [String] // 예: ["16:30", "16:45", ...]
}
