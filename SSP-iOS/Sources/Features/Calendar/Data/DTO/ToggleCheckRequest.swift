//
//  ToggleCheckRequest.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/19/25.
//

import Foundation

struct ToggleCheckRequest: Encodable {
    let routineId: Int
    let date: String
    let completed: Bool
}
