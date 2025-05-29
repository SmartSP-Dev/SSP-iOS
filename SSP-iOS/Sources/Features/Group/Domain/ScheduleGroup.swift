//
//  ScheduleGroup.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/5/25.
//

import Foundation

struct ScheduleGroup: Identifiable {
    let id = UUID()
    let name: String
    let startDate: Date
    let endDate: Date
    let groupKey: String

    var dateRangeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 d일"
        return "\(formatter.string(from: startDate)) ~ \(formatter.string(from: endDate))"
    }
}
