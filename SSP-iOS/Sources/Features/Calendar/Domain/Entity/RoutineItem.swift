//
//  RoutineItem.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/16/25.
//

import Foundation

struct RoutineItem: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    let createdDate: Date
}
