//
//  Date+Extension.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/15/25.
//

import Foundation

extension Date {
    var onlyDate: Date {
        Calendar.current.startOfDay(for: self)
    }
}
