//
//  CacheManager.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 8.12.2023.
//

import Foundation

/// A singleton class responsible for managing cached data using `UserDefaults`.
///
/// `CacheManager` provides methods to store and retrieve various types of data
/// such as `Data`, `String`, `Bool`, and `Array` in the `UserDefaults`.
/// The class follows the singleton pattern, ensuring only one instance is used
/// throughout the app.
///
/// - Note: This class uses `UserDefaults.standard` to store and retrieve data.
///
/// # Usage
/// ```
/// CacheManager.shared.setObject("Value", key: "exampleKey")
/// let value = CacheManager.shared.getString(key: "exampleKey")
/// ```
final class CacheManager {

    // MARK: - STATIC PROPERTIES

    /// The shared singleton instance of `CacheManager`.
    static let shared = CacheManager()

    // MARK: - LIFECYCLE

    /// Private initializer to ensure singleton pattern.
    ///
    /// Use `CacheManager.shared` to access the instance.
    private init() { }

    // MARK: - PRIVATE PROPERTIES

    /// The instance of `UserDefaults` used to store and retrieve data.
    private var userDefaults = UserDefaults.standard

    // MARK: - FUNCTIONS

    /// Stores an object in `UserDefaults` for the given key.
    ///
    /// - Parameters:
    ///   - value: The value to store. Can be any type supported by `UserDefaults`.
    ///   - key: The key used to store the object.
    ///
    /// - Note: This function will call `synchronizeData()` to ensure
    ///         data is immediately saved to disk.
    func setObject(_ value: Any?, key: String) {
        userDefaults.set(value, forKey: key)
        synchronizeData()
    }

    /// Retrieves a `Data` object from `UserDefaults` for the given key.
    ///
    /// - Parameter key: The key used to retrieve the object.
    /// - Returns: The `Data` object if it exists, otherwise `nil`.
    func getObject(key: String) -> Data? {
        return userDefaults.data(forKey: key)
    }

    /// Retrieves a `String` from `UserDefaults` for the given key.
    ///
    /// - Parameter key: The key used to retrieve the string.
    /// - Returns: The `String` if it exists, otherwise `nil`.
    func getString(key: String) -> String? {
        return userDefaults.string(forKey: key)
    }

    /// Retrieves a `Boolean` value from `UserDefaults` for the given key.
    ///
    /// - Parameter key: The key used to retrieve the boolean value.
    /// - Returns: The `Bool` value. If the key does not exist, the default value is `false`.
    func getBoolObject(key: String) -> Bool {
        return userDefaults.bool(forKey: key)
    }

    /// Retrieves an `Array` from `UserDefaults` for the given key.
    ///
    /// - Parameter key: The key used to retrieve the array.
    /// - Returns: The `Array` of `Any` if it exists, otherwise `nil`.
    func getArrayObject(key: String) -> [Any]? {
        return userDefaults.array(forKey: key)
    }

    /// Synchronizes the `UserDefaults` data to disk.
    ///
    /// - Note: This method is called after setting any data to ensure
    ///         it is immediately written to disk.
    func synchronizeData() {
        userDefaults.synchronize()
    }
}
