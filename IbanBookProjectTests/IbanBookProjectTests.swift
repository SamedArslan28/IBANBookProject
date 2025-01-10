//
//  IbanBookProjectTests.swift
//  IbanBookProjectTests
//
//  Created by Abdulsamed Arslan on 9.01.2025.
//

import Testing
@testable import IbanBookProject


extension Tag {
    @Tag static var demoTag:Self

}

@Suite(.tags(.demoTag)) struct IbanBookProjectTests {
    let cacheManager =  CacheManager.shared
//    @Test("dasdadas",arguments:[12,
//                                "asdasd",
//                                true])
//    func example(testdata: [Any]) {
//        let myArray = testdata
//        cacheManager.setObject(testdata,
//                               key: "randomArray")
//        let takenArray = cacheManager.getArrayObject(key: "randomArray")
//        #expect(takenArray. == testdata)
//    }
    
    @Test
    func testCacheManagerString() throws {
        let testString = "Hello, World!"
        cacheManager.setObject(testString, key: "testString")
        let takenString = try #require(cacheManager.getString(key: "testString"))
        #expect(takenString == testString)
    }
}

//struct Demo: CustomTestStringConvertible {
//    var testDescription: String {
//        "
//    }
//
//    <#fields#>
//}

