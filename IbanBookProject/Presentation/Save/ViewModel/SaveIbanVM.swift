//
//  SaveIbanVM.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 2.12.2023.
//

import Foundation

final class SaveIbanVM {
    
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

/*
Halkbank
VakıfBank
Ziraat Bankası
Akbank
Anadolubank
Fibabanka
Şekerbank
Turkish Bank
Türk Ticaret Bankası
Türkiye İş Bankası
Yapı Kredi
Alternatif Bank
Arap Türk Bankası
Bank of China Turkey
Burgan Bank
Citibank
DenizBank
Deutsche Bank
Garanti BBVA
HSBC
ICBC Turkey Bank
ING
MUFG Bank Turkey A.Ş.
Odeabank
QNB Finansbank
Rabobank
Turkland Bank A.Ş.
TEB
Bank Mellat
Habib Bank
Intesa Sanpaolo
JPMorgan Chase Bank
Société Générale
Birleşik Fon Bankası */

