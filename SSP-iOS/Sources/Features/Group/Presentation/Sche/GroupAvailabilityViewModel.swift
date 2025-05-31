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
    private let fetchWeightAndMembersUseCase: FetchWeightAndMembersUseCase

    @Published var selectedInfo: MemberAvailabilityInfo?

    private let groupRepository: GroupRepository

    init(
        group: ScheduleGroup,
        fetchWeightAndMembersUseCase: FetchWeightAndMembersUseCase,
        groupRepository: GroupRepository
    ) {
        self.group = group
        self.fetchWeightAndMembersUseCase = fetchWeightAndMembersUseCase
        self.groupRepository = groupRepository
    }
    
    func loadMembers(for dayOfWeek: String, time: String) {
        Task {
            do {
                let result = try await fetchWeightAndMembersUseCase.execute(
                    groupKey: group.groupKey,
                    dayOfWeek: dayOfWeek,
                    time: time
                )
                selectedInfo = MemberAvailabilityInfo(
                    weight: result.weight,
                    members: result.members,
                    dayOfWeek: dayOfWeek,
                    time: time
                )
            } catch {
                print("불러오기 실패: \(error.localizedDescription)")
                selectedInfo = nil
            }
        }
    }

    func clearSelection() {
        selectedInfo = nil
    }
    
    func fetchTimetable() async {
        do {
            let blocks = try await groupRepository.fetchGroupTimetable(groupKey: group.groupKey)
            print("그룹 전체 시간표 응답: \(blocks)")
            
            var map: [TimeSlot: Int] = [:]
            for block in blocks {
                if let slot = block.toTimeSlot(reference: group.startDate) {
                    map[slot] = block.weight
                }
            }
            self.slotCountMap = map
        } catch {
            print("그룹 전체 시간표 로딩 실패: \(error)")
        }
    }
}

struct MemberAvailabilityInfo: Equatable {
    let weight: Int
    let members: [String]
    let dayOfWeek: String
    let time: String
}
