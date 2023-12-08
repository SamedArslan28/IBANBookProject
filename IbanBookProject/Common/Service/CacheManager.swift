//
//  CacheManager.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 8.12.2023.
//

import Foundation

final class CacheManager {
    static let shared = CacheManager()
    private init() { }
    private var userDefaults = UserDefaults.standard
    
    func setObject(_ value: Any?, key: String) {
        userDefaults.set(value, forKey: key)
        userDefaults.synchronize()
    }
    
    func getObject(key: String) -> Data? {
        return userDefaults.data(forKey: key)
    }
}
