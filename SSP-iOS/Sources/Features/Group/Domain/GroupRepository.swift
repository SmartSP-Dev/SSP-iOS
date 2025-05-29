//
//  GroupRepository.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/29/25.
//

import Foundation

protocol GroupRepository {
    func fetchMyGroups() async throws -> [GroupResponseDTO]
    func createGroup(startDate: String, endDate: String, groupName: String) async throws -> GroupResponseDTO
    func joinGroup(groupKey: String) async throws -> Bool

}
