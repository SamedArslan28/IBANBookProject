//
//  IbanDataModel.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 19.09.2024.
//

class IbanDataModel {
    let bankName: String
    let iban: String
    let name: String

    init (
        bankName: String = "",
        iban: String = "",
        name: String = ""
    )
    {
        self.bankName = bankName
        self.iban = iban
        self.name = name
    }
}
