//
//  GroupResponseDTO.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/29/25.
//

import Foundation

struct GroupResponseDTO: Decodable {
    let groupId: Int
    let groupName: String
    let groupKey: String
}

extension GroupResponseDTO {
    func toScheduleGroup() -> ScheduleGroup {
        return ScheduleGroup(
            name: groupName,
            startDate: Date(), // 실제 API에 날짜 추가되면 교체
            endDate: Date()
        )
    }
}
