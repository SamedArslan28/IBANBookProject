//
//  IbanModel.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 11.11.2023.
//

import Foundation

final class IbanModel: Codable {

    var itemId: String = ""
    var ibanNumber: String = ""
    var bankName: String = ""
    var ibanName: String = ""
    var isFavorite: Bool = false
    
    init(ibanNumber: String, bankName: String, ibanName: String, isFavorite: Bool = false) {
        self.itemId =  UUID().uuidString
        self.ibanNumber = ibanNumber
        self.bankName = bankName
        self.ibanName = ibanName
        self.isFavorite = isFavorite
    }
}
