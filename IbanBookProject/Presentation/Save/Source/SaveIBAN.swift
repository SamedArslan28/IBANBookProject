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
        prepareUI()
    }
    
    
    // MARK: - FUNCTIONS
    
    private func setupUI() {
        IBANNumberLabel.text = viewModel.IBANNumberLabelText
        nameLabel.text = viewModel.nameLabelText
        bankNameLabel.text = viewModel.bankNameLabelText
        saveButton.setTitle("Kaydet", for: .normal)
        nameTextField.placeholder = viewModel.nameTextFieldPlaceholder
        ibanTextField.placeholder = viewModel.ibanTextFieldPlaceholder
        bankNameTextField.placeholder = viewModel.bankNameTextFieldPlaceholder
        ibanList = viewModel.getIbanList()
       
        
    }
    private func prepareUI(){
        setNavigationTitle(title: "IBAN Kaydet")
    }
    
    @IBAction func saveButtonClicked(_ sender: BaseButton) {
        
        guard let ibanText = ibanTextField.text, ibanText.isIban() else {
            
            let alertController = UIAlertController(title: "IBAN dogru degil", message: "IBAN numarasini kontrol edin", preferredStyle: .alert)
            
            let dismissAction = UIAlertAction(title: "Tamam", style: .default) { _ in
                // Handle any action you want to perform when the dismiss button is tapped
                
            }
            // You can show an alert or update the UI to inform the user about the error
            alertController.addAction(dismissAction)
            
            self.present(alertController, animated: true, completion: nil)
            return
        }
        let newItem = IbanModel(ibanNumber: ibanText, bankName: bankNameTextField.text!, ibanName: nameTextField.text!)
        ibanList.append(newItem)
        viewModel.saveIban(ibanList: ibanList)
        
    }
    
}
