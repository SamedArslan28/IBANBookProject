//
//  SaveIbanVM.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 2.12.2023.
//

import Foundation

final class SaveIbanVM{
    
    // MARK: - PRIVATE PROPERTIES
    
    private var ibanList = [IbanModel]()
    
    // MARK: - METHODS
    
    func saveIban(ibanList: [IbanModel]) {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(ibanList) else { return }
        CacheManager.shared.setObject(data, key: "ibans")
    }
    
    func getIbanList() -> [IbanModel]? {
        let decoder = JSONDecoder()
        guard let ibans = CacheManager.shared.getObject(key: "ibans") else { return nil }
        return try? decoder.decode([IbanModel].self, from: ibans)
    }
}

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
