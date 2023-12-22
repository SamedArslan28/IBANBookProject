//
//  SaveIBAN.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 6.11.2023.
//

import Foundation
import UIKit

final class SaveIbanVC: BaseVC, Navigable {
    
    // MARK: - PROPERTIES
    
    var viewModel = SaveIbanVM()
    var ibanList = [IbanModel]()
    
    // MARK: - Outlets
    
    @IBOutlet private weak var IBANNumberLabel: BaseLabel!
    @IBOutlet private weak var nameLabel: BaseLabel!
    @IBOutlet private weak var bankNameLabel: BaseLabel!
    @IBOutlet private weak var saveButton: BaseButton!
    @IBOutlet private weak var nameTextField: BaseTextField!
    @IBOutlet private weak var ibanTextField: BaseTextField!
    @IBOutlet private weak var bankNameTextField: BaseTextField!
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - FUNCTIONS
    
    private func setupUI() {
        IBANNumberLabel.text = SaveIbanConstants.ibanNumberLabelText
        nameLabel.text = SaveIbanConstants.fullNameLabelText
        bankNameLabel.text = SaveIbanConstants.bankNameLabelText
        saveButton.setTitle("Kaydet", for: .normal)
        nameTextField.placeholder = SaveIbanConstants.nameTextFieldPlaceholder
        nameTextField.setPlaceholderColor(.black , alpha: 0.6)
        ibanTextField.placeholder = SaveIbanConstants.ibanTextFieldPlaceholder
        ibanTextField.setPlaceholderColor(.black, alpha: 0.6)
        bankNameTextField.placeholder = SaveIbanConstants.bankNameTextFieldPlaceholder
        bankNameTextField.setPlaceholderColor(.black, alpha: 0.6)
        nameTextField.setbackg(color: .clear)
        ibanTextField.setbackg(color: .clear)
        bankNameTextField.setbackg(color: .clear)
        nameTextField.setBorderColor(color: UIColor.lightGray.cgColor)
        ibanTextField.setBorderColor(color: UIColor.lightGray.cgColor)
        bankNameTextField.setBorderColor(color: UIColor.lightGray.cgColor)
        nameTextField.setBorderWith(witdht: 2)
        ibanTextField.setBorderWith(witdht: 2)
        bankNameTextField.setBorderWith(witdht: 2)
        nameTextField.setBorderStyle(.none)
        bankNameTextField.setBorderStyle(.none)
        ibanTextField.setBorderStyle(.none)
        nameTextField.setFontSize(16)
        ibanTextField.setFontSize(16)
        nameTextField.setFontSize(16)
        ibanList = viewModel.getIbanList() ?? []
        setNavigationTitle(title: "IBAN Kaydet")
    }
    
    @IBAction private func saveButtonClicked(_ sender: BaseButton) {
        guard let ibanText = ibanTextField.text, ibanText.isIban() else {
            showActionAlertCancel(errorTitle: IbanReaderManangerConstants.alertTitle, errorMessage: IbanReaderManangerConstants.alertMessage)
            return
        }
        let newItem = IbanModel(ibanNumber: ibanText, bankName: bankNameTextField.text!, ibanName: nameTextField.text!)
        ibanList.append(newItem)
        viewModel.saveIban(ibanList: ibanList)
        
        
    }
}
