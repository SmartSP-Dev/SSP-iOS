//
//  KeychainManager.swift
//  SSP-iOS
//
//  Created by 황상환 on 5/13/25.
//

import Foundation
import KeychainAccess

final class KeychainManager {
    static let shared = KeychainManager()

    private let keychain = Keychain(service: "io.tuist.SSP-iOS")

    private enum Key: String {
        case accessToken
        case refreshToken
    }

    // MARK: - Save

    func saveAccessToken(_ token: String) {
        try? keychain.set(token, key: Key.accessToken.rawValue)
    }

    func saveRefreshToken(_ token: String) {
        try? keychain.set(token, key: Key.refreshToken.rawValue)
    }

    // MARK: - Load

    var accessToken: String? {
        return try? keychain.get(Key.accessToken.rawValue)
    }

    var refreshToken: String? {
        return try? keychain.get(Key.refreshToken.rawValue)
    }

    // MARK: - Delete

    func deleteTokens() {
        try? keychain.remove(Key.accessToken.rawValue)
        try? keychain.remove(Key.refreshToken.rawValue)
    }
    // MARK: - Vaild
    func isAccessTokenValid() -> Bool {
        guard let token = accessToken else { return false }
        return !JWTDecoder.isExpired(token: token)
    }

}
