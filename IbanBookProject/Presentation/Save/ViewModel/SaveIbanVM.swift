//
//  SaveIbanVM.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 2.12.2023.
//

import Foundation

final class SaveIbanVM{
    

    // MARK: - PROPERTIES
    
    var IBANNumberLabelText: String {
        return "IBAN"
    }
    
    var nameLabelText: String {
        return "Ad Soyad"
    }
    
    var bankNameLabelText: String {
        return "Banka Adı"
    }
    
    var saveButtonTitle: String {
        return "Kaydet"
    }
    
    var nameTextFieldPlaceholder: String {
        return "Ad Soyad"
    }
    
    var ibanTextFieldPlaceholder: String {
        return "TR00 0000 0000 0000 0000 0000 00"
    }
    
    var bankNameTextFieldPlaceholder: String {
        return "Banka Adı"
    }
    
    
    // MARK: - PRIVATE PROPERTIES
    
    private var userDefaults = UserDefaults.standard
    private var ibanList = [IbanModel]()
    
    
    // MARK: - METHODS
    
    func saveIban(ibanList: [IbanModel]) {
        do {
            // Create JSON Encoder
            let encoder = JSONEncoder()
            
            // Encode IbanModel list
            let data = try encoder.encode(ibanList)
            
            // Write/Set Data
            userDefaults.set(data, forKey: "ibans")
            
        } catch {
            print("Unable to Encode IbanModel list (\(error))")
        }
        
        userDefaults.synchronize()
    }
    
    func getIbanList() -> [IbanModel] {
        
        if let savedList = userDefaults.data(forKey: "ibans") {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()
                
                // Decode IbanModel list
                ibanList = try decoder.decode([IbanModel].self, from: savedList)
                
            } catch {
                print("Unable to Decode IbanModel list (\(error))")
            }
        }
        
        return ibanList
    }
    
    
}
