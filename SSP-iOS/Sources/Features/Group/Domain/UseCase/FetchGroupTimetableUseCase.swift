//
//  FetchGroupTimetableUseCase.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/30/25.
//

import Foundation

protocol FetchGroupTimetableUseCase {
    func execute(groupKey: String) async throws -> [TimeBlockDTO]
}
