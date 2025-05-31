//
//  WeightAndMembersResponse.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/31/25.
//

import Foundation

struct WeightAndMembersResponse: Decodable {
    let weight: Int
    let members: [String]
}
