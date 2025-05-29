//
//  GroupHomeViewModel.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/29/25.
//

import Foundation

@MainActor
final class GroupHomeViewModel: ObservableObject {
    @Published var groups: [GroupResponseDTO] = []
    
    private let fetchMyGroupsUseCase: FetchMyGroupsUseCase
    private let createGroupUseCase: CreateGroupUseCase
    private let joinGroupUseCase: JoinGroupUseCase

    init(
        fetchMyGroupsUseCase: FetchMyGroupsUseCase,
        createGroupUseCase: CreateGroupUseCase,
        joinGroupUseCase: JoinGroupUseCase
    ) {
        self.fetchMyGroupsUseCase = fetchMyGroupsUseCase
        self.createGroupUseCase = createGroupUseCase
        self.joinGroupUseCase = joinGroupUseCase
    }
    
    func fetchGroups() async {
        do {
            let result = try await fetchMyGroupsUseCase.execute()
            print("[그룹 리스트 조회 결과]:", result)
            self.groups = result
        } catch {
            print("그룹 목록 조회 실패: \(error)")
        }
    }

    func appendGroup(_ group: GroupResponseDTO) {
        groups.append(group)
    }
    
    func createGroup(startDate: Date, endDate: Date, name: String) async {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        do {
            let response = try await createGroupUseCase.execute(
                startDate: formatter.string(from: startDate),
                endDate: formatter.string(from: endDate),
                groupName: name
            )
            print("[방 생성 응답]:", response)
            groups.append(response)
        } catch {
            print("그룹 생성 실패: \(error)")
        }
    }

    func joinGroup(groupKey: String) async -> Bool {
        do {
            let success = try await joinGroupUseCase.execute(groupKey: groupKey)
            print("[방 참여 응답 - 성공 여부]:", success)
            return success
        } catch {
            print("방 참여 실패: \(error)")
            return false
        }
    }
}
