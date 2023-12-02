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
    
    @IBAction func saveButtonClicked(_ sender: BaseButton) {
        
        let newItem = IbanModel(ibanNumber: ibanTextField.text!, bankName: bankNameTextField.text!, ibanName: nameTextField.text!)
        ibanList.append(newItem)
        viewModel.saveIban(ibanList: ibanList)
        
    }
    // MARK: - PROPERTIES
    
    private let viewModel = SaveIbanVM()
    var ibanList = [IbanModel]()
    
    // MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationTitle(title: "IBAN Kaydet")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        ibanList = viewModel.getIbanList()
        IBANNumberLabel.text = viewModel.IBANNumberLabelText
        nameLabel.text = viewModel.nameLabelText
        bankNameLabel.text = viewModel.bankNameLabelText
        saveButton.setTitle("Kaydet", for: .normal)
        nameTextField.placeholder = viewModel.nameTextFieldPlaceholder
        ibanTextField.placeholder = viewModel.ibanTextFieldPlaceholder
        bankNameTextField.placeholder = viewModel.bankNameTextFieldPlaceholder
    }
    
}
