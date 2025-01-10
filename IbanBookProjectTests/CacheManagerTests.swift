//
//  CacheManagerTests.swift
//  IbanBookProjectTests
//
//  Created by Abdulsamed Arslan on 9.01.2025.
//

import Testing
@testable import IbanBookProject

struct CacheManagerTests {
    let cacheManager =  CacheManager.shared

    @Test
    func testCacheManagerString() throws {
        let testString = "Hello, World!"
        cacheManager.setObject(testString, key: "testString")
        let takenString = try #require(cacheManager.getString(key: "testString"))
        #expect(takenString == testString)
    }

    @Test("CacheManager Bool Test")
    func testCacheManagerBool() throws {
        let testBool = true
        cacheManager.setObject(testBool, key: "testBool")
        let takenBool = cacheManager.getBoolObject(key: "testBool")
        #expect(takenBool == testBool)
    }
}
