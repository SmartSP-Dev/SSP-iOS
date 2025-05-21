//
//  FetchWeekQuizResponse.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/20/25.
//

import Foundation

struct FetchWeekQuizResponse: Decodable {
    let total: Int
    let reviewed: Int
    let notReviewed: Int
}
