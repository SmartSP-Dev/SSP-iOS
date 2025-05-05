//
//  GroupScheduleView.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/5/25.
//

import SwiftUI

struct TimeSlot: Hashable {
    let day: String
    let hour: Int
}

struct GroupScheduleView: View {
    let group: ScheduleGroup
    @State private var selectedSlots: Set<TimeSlot> = []
    @State private var showSaveButton = false

    private let days: [String] = ["월", "화", "수", "목", "금", "토", "일"]
    private let hours: [Int] = Array(8...22)

    var body: some View {
        VStack {
            Text(group.name)
                .font(.title2)
                .padding(.bottom, 10)

            ScrollView([.horizontal, .vertical]) {
                LazyVStack(spacing: 1) {
                    HStack(spacing: 1) {
                        Text("")
                            .frame(width: 50)

                        ForEach(days, id: \.self) { day in
                            Text(day)
                                .font(.caption)
                                .frame(width: 44, height: 30)
                                .background(Color.gray.opacity(0.2))
                        }
                    }

                    ForEach(hours, id: \.self) { hour in
                        HStack(spacing: 1) {
                            Text("\(hour)시")
                                .font(.caption2)
                                .frame(width: 50, height: 44)
                                .background(Color.gray.opacity(0.2))

                            ForEach(days, id: \.self) { day in
                                let slot = TimeSlot(day: day, hour: hour)
                                Rectangle()
                                    .fill(selectedSlots.contains(slot) ? Color.blue.opacity(0.7) : Color.gray.opacity(0.1))
                                    .frame(width: 44, height: 44)
                                    .onTapGesture {
                                        toggle(slot)
                                    }
                            }
                        }
                    }
                }
            }

            if showSaveButton {
                Button("시간 저장하기") {
                    print("선택된 시간: \(selectedSlots)")
                    showSaveButton = false
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.top)
            }
        }
        .padding()
        .navigationTitle("시간 선택")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func toggle(_ slot: TimeSlot) {
        if selectedSlots.contains(slot) {
            selectedSlots.remove(slot)
        } else {
            selectedSlots.insert(slot)
        }
        showSaveButton = true
    }
}

// MARK: - Preview

#Preview {
    NavigationView {
        GroupScheduleView(group: ScheduleGroup(name: "스터디 약속", dateRange: "5월 10일 ~ 5월 16일"))
    }
}
