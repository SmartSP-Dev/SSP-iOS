//
//  UploadFileUseCase.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/23/25.
//

import Foundation

protocol UploadFileUseCase {
    func execute(fileURL: URL) async throws
}
