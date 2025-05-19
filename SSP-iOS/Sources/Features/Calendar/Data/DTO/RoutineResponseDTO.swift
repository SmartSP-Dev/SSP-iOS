//
//  RoutineResponseDTO.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/19/25.
//

import Foundation

struct RoutineResponseDTO: Decodable {
    let routineId: Int
    let title: String
    let completed: Bool
}
