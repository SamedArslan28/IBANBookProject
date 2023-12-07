//
//  IbanCellVM.swift
//  IbanBookProject
//
//  Created by Göksu Subaşı on 30.11.2023.
//

import Foundation

struct IbanCellVM {
    private let ibanModel: IbanModel
    
    var iban: String { ibanModel.ibanNumber }
    var ibanName: String { ibanModel.ibanName }
    var bankName: String { ibanModel.bankName }
    
    init(ibanModel: IbanModel) {
        self.ibanModel = ibanModel
    }
}
