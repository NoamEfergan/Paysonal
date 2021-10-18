//
//  SecureStorageManager.swift
//  Paysonal
//
//  Created by Noam Efergan on 18/10/2021.
//

import Foundation
import CryptoSwift
import KeychainAccess

final class SecureStorageManager {

    // MARK: - Variables

    private(set) static var shared = SecureStorageManager()

    // MARK: - Public methods

    @discardableResult static func storeHashedPassword(hashedPassword: String) -> Bool {
        let keychain = Keychain.init(service: AppConstants.keyChain)
        // Reverse the password before storing it
        do {
            try keychain.set(hashedPassword, key: AppConstants.hashedPass)
            return true
        } catch {
            print("Error while storing the hashed password")
            return false
        }
    }

    static func getHashedPassword() -> String? {
        let keychain = Keychain.init(service: AppConstants.keyChain)
        guard let password = try? keychain.get(AppConstants.hashedPass)
            else { return nil }
        // Reverse the password before returning it
        return password
    }
}
