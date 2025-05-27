//
//  DefaultSaveTimetableLinkUseCase.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/27/25.
//

import Foundation

final class DefaultSaveTimetableLinkUseCase: SaveTimetableLinkUseCase {
    
    private let repository: TimetableRepository

    init(repository: TimetableRepository) {
        self.repository = repository
    }

    func executeRegister(link: String, completion: @escaping (Result<Void, Error>) -> Void) {
        repository.registerTimetable(link, completion: completion)
    }
}
