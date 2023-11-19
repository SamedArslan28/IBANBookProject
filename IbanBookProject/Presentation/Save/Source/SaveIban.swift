//
//  SaveIBAN.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 6.11.2023.
//

import Foundation
import UIKit

final class SaveIBAN: BaseVC {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var IBANNumberLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet weak var bankNameLabel: UILabel!
    @IBOutlet private weak var saveButton: BaseButton!
    @IBOutlet weak var nameTextField: BaseTextField!
    @IBOutlet weak var ibanTextField: BaseTextField!
    
    @IBOutlet weak var bankNameTextField: BaseTextField!
    
    
    let userDefaults = UserDefaults.standard
    var ibanList = [IbanModel]()
    
    
    
    @IBAction func saveButtonClicked(_ sender: BaseButton) {
        
        
        
        let newItem = IbanModel(ibanNumber: ibanTextField.text!, bankName: bankNameTextField.text!, ibanName: nameTextField.text!)
        print(newItem.itemId)
        print(newItem.isFav)
        
        
        
        
        ibanList.append(IbanModel(ibanNumber: newItem.ibanNumber, bankName: newItem.bankName, ibanName: newItem.ibanName))
        
        do {
            // Create JSON Encoder
            let encoder = JSONEncoder()
            
            // Encode Note
            let data = try encoder.encode(ibanList)
            
            // Write/Set Data
            userDefaults.set(data, forKey: "ibanList")
            
        } catch {
            print("Unable to Encode Note (\(error))")
        }
        UserDefaults.standard.synchronize()
    }
    // MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationTitle(title: "IBAN Kaydet")
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        IBANNumberLabel.text = "IBAN"
        nameLabel.text = "Ad Soyad"
        bankNameLabel.text = "Banka Adı"
        saveButton.setTitle("Kaydet", for: .normal)
        nameTextField.placeholder = "Ad Soyad"
        ibanTextField.placeholder = "TR00 0000 0000 0000 0000 0000 00"
        bankNameTextField.placeholder = "Banka Adı"
        
        
        
        
        if let savedList = userDefaults.data(forKey: "ibanList") {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()
                
                // Decode Note
                let note = try decoder.decode([IbanModel].self, from: savedList)
                ibanList = note
                print(ibanList.count)
                
                
            } catch {
                print("Unable to Decode Note (\(error))")
            }
        }
        
        
        
        
    }
    
}
