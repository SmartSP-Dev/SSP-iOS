//
//  FetchWeightAndMembersUseCase.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/31/25.
//

import Foundation

protocol FetchWeightAndMembersUseCase {
    func execute(groupKey: String, dayOfWeek: String, time: String) async throws -> (weight: Int, members: [String])
}
