//
//  GroupScheduleView.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/5/25.
//

import SwiftUI

struct GroupScheduleView: View {
    @EnvironmentObject var router: NavigationRouter
    let group: ScheduleGroup
    @StateObject private var viewModel: GroupScheduleViewModel

    private let hours = Array(8...22)

    init(group: ScheduleGroup) {
        self.group = group
        _viewModel = StateObject(wrappedValue: DIContainer.shared.makeGroupScheduleViewModel(group: group))
    }

    private var weekDates: [Date] {
        let calendar = Calendar(identifier: .gregorian)
        var calendarMondayStart = calendar
        calendarMondayStart.firstWeekday = 2  // 월요일을 주 시작일로 설정

        guard let startOfWeek = calendarMondayStart.dateInterval(of: .weekOfYear, for: viewModel.group.startDate)?.start else {
            return []
        }

        return (0..<7).compactMap {
            calendarMondayStart.date(byAdding: .day, value: $0, to: startOfWeek)
        }
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

            HStack {
                HStack(spacing: 4) {
                    Rectangle()
                        .fill(Color.black.opacity(0.2))
                        .frame(width: 12, height: 12)
                        .cornerRadius(2)
                    Text("에타 시간표")
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                HStack(spacing: 4) {
                    Rectangle()
                        .fill(Color.pink.opacity(0.2))
                        .frame(width: 12, height: 12)
                        .cornerRadius(2)
                    Text("달력 일정")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            Button("시간 저장하기") {
                Task {
                    await viewModel.saveUserSchedule(groupKey: group.groupKey)

                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.black.opacity(0.7))
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
        .navigationTitle("시간 선택")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                viewModel.fetchCalendarEvents()
                await viewModel.fetchUserSchedule(groupKey: group.groupKey)
                await viewModel.loadMyCalendarSchedule()
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    router.goBack()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black.opacity(0.7))
                    Text("Back")
                        .foregroundColor(.black.opacity(0.7))
                }
            }
        }
    }
}

