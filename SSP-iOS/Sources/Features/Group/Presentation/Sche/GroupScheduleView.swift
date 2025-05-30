//
//  GroupScheduleView.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/5/25.
//

import SwiftUI

struct GroupScheduleView: View {
    let group: ScheduleGroup
    @StateObject private var viewModel: GroupScheduleViewModel

    private let hours = Array(8...22)

    init(group: ScheduleGroup) {
        self.group = group
        _viewModel = StateObject(wrappedValue: DIContainer.shared.makeGroupScheduleViewModel(group: group))
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
                busyFromSchedule: [],
                busyFromEvent: viewModel.busyFromEvent,
                busyFromCalendar: viewModel.calendarSlots,
                onToggle: { viewModel.toggle($0) }
            )

            Button("시간 저장하기") {
                Task {
                    await viewModel.saveUserSchedule(groupKey: group.groupKey)

                }
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
            Task {
                viewModel.fetchCalendarEvents()
                await viewModel.fetchUserSchedule(groupKey: group.groupKey)
                await viewModel.loadMyCalendarSchedule()
            }
        }
    }
}

