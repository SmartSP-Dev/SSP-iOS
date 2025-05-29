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
        let today = Date()  
        let (start, end) = today.weekBounds()

        return ScheduleGroup(
            name: groupName,
            startDate: start,
            endDate: end,
            groupKey: groupKey
        )
    }
}

