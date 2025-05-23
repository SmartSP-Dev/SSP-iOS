//
//  DeleteQuizUseCase.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/23/25.
//

import Foundation

protocol DeleteQuizUseCase {
    func execute(id: Int) async throws
}
