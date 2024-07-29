//
//  IbanCellVM.swift
//  IbanBookProject
//
//  Created by Göksu Subaşı on 30.11.2023.
//

import Foundation

class IbanCellVM {
    
    // MARK: - PRIVATE PROPERTIES
    
    private var ibanModel: IbanModel
    var rowType: SectionTypes
    
    // MARK: - COMPUTED PROPERTIES
    
    var iban: String { ibanModel.ibanNumber }
    var ibanName: String { ibanModel.ibanName }
    var bankName: String { ibanModel.bankName }
    var id: String { ibanModel.itemId }
    var isFav: Bool { ibanModel.isFavorite }
    
    // MARK: - LIFECYCLE
    
    init(ibanModel: IbanModel, rowType: SectionTypes) {
        self.ibanModel = ibanModel
        self.rowType = rowType
    }
}
