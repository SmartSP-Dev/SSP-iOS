//
//  MonthlySummaryDTO.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/14/25.
//

import Foundation

struct MonthlySummaryDTO: Decodable {
    let studyDay: Int
    let studyTime: Int
    let averageStudyTime: Int
    let maxStudyTime: Int
}
