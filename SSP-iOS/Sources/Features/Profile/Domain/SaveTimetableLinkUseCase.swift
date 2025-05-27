//
//  SaveTimetableLinkUseCase.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/27/25.
//

import Foundation

protocol SaveTimetableLinkUseCase {
    func executeRegister(link: String, completion: @escaping (Result<Void, Error>) -> Void)
}
