//
//  CacheManager.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 8.12.2023.
//

import Foundation

final class CacheManager {
    
    // MARK: - STATIC PROPERTIES
    
    static let shared = CacheManager()
    
    // MARK: - LIFECYCLE
    
    private init() { }
    
    // MARK: - PRIVATE PROPERTIES
    
    private var userDefaults = UserDefaults.standard
    
    // MARK: - FUNCTIONS
    
    func setObject(_ value: Any?, key: String) {
        userDefaults.set(value, forKey: key)
        synchronizeData()
    }
    
    func getObject(key: String) -> Data? {
        return userDefaults.data(forKey: key)
    }
    func synchronizeData() {
        userDefaults.synchronize()
    }
}
