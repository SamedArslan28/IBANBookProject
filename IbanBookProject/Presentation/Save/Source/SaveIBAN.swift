//
//  SaveIBAN.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 6.11.2023.
//

import Foundation
import UIKit

final class SaveIBAN: BaseVC {
    
    // MARK: - PROPERTIES
    
    var viewModel = SaveIbanVM()
    var ibanList = [IbanModel]()
    
    // MARK: - Outlets
    
    @IBOutlet private weak var IBANNumberLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet weak var bankNameLabel: UILabel!
    @IBOutlet private weak var saveButton: BaseButton!
    @IBOutlet weak var nameTextField: BaseTextField!
    @IBOutlet weak var ibanTextField: BaseTextField!
    @IBOutlet weak var bankNameTextField: BaseTextField!
    
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    // MARK: - FUNCTIONS
    
    private func setupUI() {
        setNavigationTitle(title: "IBAN Kaydet")
        IBANNumberLabel.text = viewModel.IBANNumberLabelText
        nameLabel.text = viewModel.nameLabelText
        bankNameLabel.text = viewModel.bankNameLabelText
        saveButton.setTitle("Kaydet", for: .normal)
        nameTextField.placeholder = viewModel.nameTextFieldPlaceholder
        ibanTextField.placeholder = viewModel.ibanTextFieldPlaceholder
        bankNameTextField.placeholder = viewModel.bankNameTextFieldPlaceholder
        ibanList = viewModel.getIbanList()
        
    }
    
    @IBAction func saveButtonClicked(_ sender: BaseButton) {
        
        guard let ibanText = ibanTextField.text, ibanText.isIban() else {
            print("Invalid IBAN or missing IBAN text")
            return
        }
        let newItem = IbanModel(ibanNumber: ibanText, bankName: bankNameTextField.text!, ibanName: nameTextField.text!)
        ibanList.append(newItem)
        viewModel.saveIban(ibanList: ibanList)
        
    }
    
}
