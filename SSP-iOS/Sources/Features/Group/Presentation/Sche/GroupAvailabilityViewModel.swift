//
//  GroupAvailabilityViewModel.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/29/25.
//

import Foundation

@MainActor
final class GroupAvailabilityViewModel: ObservableObject {
    @Published var slotCountMap: [TimeSlot: Int] = [:]
    let group: ScheduleGroup

    private let groupRepository: GroupRepository

    init(group: ScheduleGroup, groupRepository: GroupRepository) {
        self.group = group
        self.groupRepository = groupRepository
    }

    func fetchTimetable() async {
        do {
            let blocks = try await groupRepository.fetchGroupTimetable(groupKey: group.groupKey)
            var map: [TimeSlot: Int] = [:]
            for block in blocks {
                if let slot = block.toTimeSlot(reference: group.startDate) {
                    map[slot] = block.weight
                }
            }
            self.slotCountMap = map
        } catch {
            print("시간표 로딩 실패: \(error)")
        }
    }
}
