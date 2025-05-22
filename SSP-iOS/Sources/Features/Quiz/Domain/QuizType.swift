//
//  QuizType.swift
//  SSP-iOS
//
//  Created by 황상환 on 4/21/25.
//

import Foundation

public enum QuizType: String, Codable, CaseIterable {
    case multipleChoice
    case ox
    case fillInTheBlank
}

extension QuizType {
    init(from string: String) {
        switch string.uppercased() {
        case "OX": self = .ox
        case "FILL_BLANK": self = .fillInTheBlank
        case "MULTIPLE_CHOICE": fallthrough
        default: self = .multipleChoice
        }
    }
}
