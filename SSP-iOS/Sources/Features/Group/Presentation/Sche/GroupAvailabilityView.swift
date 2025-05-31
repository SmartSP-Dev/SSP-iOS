//
//  GroupAvailabilityView.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/8/25.
//

import SwiftUI

struct GroupAvailabilityView: View {
    @EnvironmentObject var router: NavigationRouter
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
                fetchWeightAndMembersUseCase: DIContainer.shared.makeFetchWeightAndMembersUseCase(),
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
                viewModel: viewModel,
                weekDates: weekDates,
                hours: Array(8...22),
                slotCountMap: viewModel.slotCountMap
            )
            
            ZStack {
                if let info = viewModel.selectedInfo {
                    AvailabilityInfoView(info: info)
                        .transition(.opacity)
                        .frame(height: 70)
                } else {
                    Color.clear.frame(height: 70)
                }
            }
            .animation(.easeInOut, value: viewModel.selectedInfo)
            
            Button("내 시간 수정하기") {
                router.navigate(to: .groupSchedule(group: viewModel.group))
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue.opacity(0.6))
            .foregroundStyle(Color.white)
            .cornerRadius(10)
        }
        .padding()
        .onAppear {
            Task {
                await viewModel.fetchTimetable()
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    router.goBack()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                    Text("Back")
                        .foregroundColor(.black)
                }
            }
        }
    }
}

struct AvailabilityInfoView: View {
    let info: MemberAvailabilityInfo

    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: "person.2.fill")
                .font(.system(size: 20))
                .foregroundColor(.gray)

            VStack(alignment: .leading, spacing: 6) {
                Text("\(info.members.joined(separator: ", "))")
                    .font(.subheadline)
                    .fontWeight(.semibold)

                HStack {
                    Text("\(convertToKoreanWeekday(eng: info.dayOfWeek))")
                    Text(info.time)
                }
                .font(.caption)
                .foregroundColor(.gray)
            }

            Spacer()

            Text("[\(info.weight)명]")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.black)
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .frame(maxWidth: .infinity)
    }
    
    private func convertToKoreanWeekday(eng: String) -> String {
        switch eng.uppercased() {
        case "MON": return "월요일"
        case "TUE": return "화요일"
        case "WED": return "수요일"
        case "THU": return "목요일"
        case "FRI": return "금요일"
        case "SAT": return "토요일"
        case "SUN": return "일요일"
        default: return eng
        }
    }
}


// MARK: - Subview

struct ScheduleSlotGrid: View {
    @ObservedObject var viewModel: GroupAvailabilityViewModel
    
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
                        .background(Color.blue.opacity(0.6))
                        .foregroundStyle(Color.white)
                    }
                }

                ForEach(hours, id: \.self) { hour in
                    HStack(spacing: spacing) {
                        Text("\(hour)시")
                            .font(.caption2)
                            .frame(width: timeLabelWidth, height: 28)
                            .background(Color.blue.opacity(0.6))
                            .foregroundStyle(Color.white)

                        VStack(spacing: 1) {
                            ForEach([0, 30], id: \.self) { minute in
                                HStack(spacing: spacing) {
                                    ForEach(weekDates, id: \.self) { date in
                                        let slot = TimeSlot(date: date, hour: hour, minute: minute)
                                        Rectangle()
                                            .fill(grayFor(count: slotCountMap[slot] ?? 0))
                                            .frame(width: max(1, cellWidth), height: 14)
                                            .onTapGesture {
                                                let dayOfWeek = Self.englishWeekdayString(from: date)
                                                let timeStr = String(format: "%02d:%02d", hour, minute)
                                                viewModel.loadMembers(for: dayOfWeek, time: timeStr)
                                            }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
        }
        .frame(height: 480)
    }
    
    private static func englishWeekdayString(from date: Date) -> String {
        let weekday = Calendar.current.component(.weekday, from: date)
        return ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"][weekday - 1]
    }

    private func grayFor(count: Int) -> Color {
        switch count {
        case 5...: return Color.black.opacity(0.9)
        case 4: return Color.black.opacity(0.75)
        case 3: return Color.black.opacity(0.6)
        case 2: return Color.black.opacity(0.4)
        case 1: return Color.black.opacity(0.25)
        default: return Color.black.opacity(0.05)
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

