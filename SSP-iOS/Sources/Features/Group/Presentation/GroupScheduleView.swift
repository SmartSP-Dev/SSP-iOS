//
//  GroupScheduleView.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/5/25.
//

import SwiftUI

struct GroupScheduleView: View {
    @StateObject private var viewModel: GroupScheduleViewModel

    private let hours = Array(8...22)

    init(group: ScheduleGroup) {
        _viewModel = StateObject(wrappedValue: GroupScheduleViewModel(group: group))
    }

    private var weekDates: [Date] {
        var dates: [Date] = []
        var current = viewModel.group.startDate
        while current <= viewModel.group.endDate {
            dates.append(current)
            current = Calendar.current.date(byAdding: .day, value: 1, to: current)!
        }
        return dates
    }

    var body: some View {
        VStack(spacing: 8) {
            Text(viewModel.group.name)
                .font(.title2)

            Text(viewModel.group.dateRangeString)
                .font(.caption)
                .foregroundColor(.gray)

            SlotGridView(
                weekDates: weekDates,
                hours: hours,
                selectedSlots: viewModel.selectedSlots,
                busyFromSchedule: viewModel.busyFromSchedule,
                busyFromEvent: viewModel.busyFromEvent,
                onToggle: { viewModel.toggle($0) }
            )

            Button("시간 저장하기") {
                print("선택된 시간: \(viewModel.selectedSlots)")
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
        .onAppear {
            loadMockData()
        }
    }

    private func loadMockData() {
        let jsonString = """
        {
            "schedules": [
                {
                    "timePoint": "화",
                    "subjects": [
                        {
                            "subject": "데이터베이스응용",
                            "times": ["16:30", "16:45", "17:00"]
                        }
                    ]
                },
                {
                    "timePoint": "수",
                    "subjects": [
                        {
                            "subject": "컴퓨터비전",
                            "times": ["13:30", "13:45", "14:00"]
                        }
                    ]
                }
            ]
        }
        """
        
        if let data = jsonString.data(using: .utf8),
           let parsed = try? JSONDecoder().decode(MockSchedulePayload.self, from: data) {
            viewModel.loadTimeTable(from: parsed.schedules)
        }

        // EventKit mock
        let calendar = Calendar.current
        let date = weekDates[1]
        let eventSlots: Set<TimeSlot> = [
            TimeSlot(date: date, hour: 17),
            TimeSlot(date: date, hour: 18)
        ]
        viewModel.loadEventKitSlots(eventSlots)
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

// MARK: - Mock

private struct MockSchedulePayload: Decodable {
    let schedules: [WeekScheduleDTO]
}
