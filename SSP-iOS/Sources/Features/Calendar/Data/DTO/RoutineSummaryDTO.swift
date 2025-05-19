//
//  RoutineSummaryDTO.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/19/25.
//

import Foundation

struct RoutineSummaryDTO: Decodable {
    let date: String     // "yyyy-MM-dd"
    let achieved: Bool
}
