//
//  StorageManager.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/22.
//

import Foundation
import Security

final class StorageManager {
    
    // MARK: Shared instance
    
    static let shared = StorageManager()
    private init() { }
    
    // MARK: Keychain
    private let account = "PMS"
    private let service = Bundle.main.bundleIdentifier
    
    // query
    private lazy var query: [CFString: Any]? = {
        guard let service = self.service else { return nil }
        return [kSecClass: kSecClassGenericPassword,
                kSecAttrService: service,
                kSecAttrAccount: self.account]
    }()
    
    public func createUser(user: Auth) {
        guard let data = try? JSONEncoder().encode(user),
              let service = self.service else { return }
        
        let query: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                      kSecAttrService: service,
                                      kSecAttrAccount: account,
                                      kSecAttrGeneric: data]
        
        SecItemAdd(query as CFDictionary, nil)
    }
    
    public func readUser() -> Auth? {
        guard let service = self.service else { return nil }
        let query: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                      kSecAttrService: service,
                                      kSecAttrAccount: account,
                                      kSecMatchLimit: kSecMatchLimitOne,
                                      kSecReturnAttributes: true,
                                      kSecReturnData: true]
        
        var item: CFTypeRef?
        if SecItemCopyMatching(query as CFDictionary, &item) != errSecSuccess { return nil }
        
        guard let existingItem = item as? [CFString: Any],
              let data = existingItem[kSecAttrGeneric] as? Data,
              let user = try? JSONDecoder().decode(Auth.self, from: data) else { return nil }
        
        return user
    }
    
    public func updateUser(user: Auth) {
        guard let query = self.query,
              let data = try? JSONEncoder().encode(user) else { return }
        
        let attributes: [CFString: Any] = [kSecAttrAccount: account,
                                           kSecAttrGeneric: data]
        
        SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
    }
    
    public func deleteUser() {
        guard let query = self.query else { Log.error("self query isn't here."); return }
        SecItemDelete(query as CFDictionary)
    }
}
