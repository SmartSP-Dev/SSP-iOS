//
//  TimetableRepository.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/27/25.
//

import Foundation

protocol TimetableRepository {
    func registerTimetable(_ url: String, completion: @escaping (Result<Void, Error>) -> Void)
}
