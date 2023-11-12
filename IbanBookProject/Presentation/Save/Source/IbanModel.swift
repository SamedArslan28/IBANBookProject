//
//  IbanModel.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 11.11.2023.
//

import Foundation


class IbanModel: Codable {
   
    var itemId: String
    var ibanNumber: String
    var bankName: String
    var ibanName: String
    var isFav: Bool = false
    
    init(ibanNumber: String, bankName: String, ibanName: String) {
        self.itemId = IbanModel.randomString()
        self.ibanNumber = ibanNumber
        self.bankName = bankName
        self.ibanName = ibanName
     
    }
    
    static func randomString(length: Int = 20) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString = ""
        for _ in 0 ..< length {
            let randomIndex = Int(arc4random_uniform(UInt32(letters.count)))
            let letter = letters[letters.index(letters.startIndex, offsetBy: randomIndex)]
            randomString += String(letter)
        }
        return randomString
    }
    
   
    
}
