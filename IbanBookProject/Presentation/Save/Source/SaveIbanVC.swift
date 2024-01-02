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
    let banks = ["Halkbank", "VakıfBank", "Ziraat Bankası", "Akbank", "Anadolubank", "Other"]
    var pickerView = UIPickerView()

    // MARK: - Outlets

    @IBOutlet weak var otherTextField: BaseTextField!
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
        if let data = dataa{
            ibanTextField.text = data as? String
        }
        IBANNumberLabel.text = SaveIbanConstants.ibanNumberLabelText
        nameLabel.text = SaveIbanConstants.fullNameLabelText
        bankNameLabel.text = SaveIbanConstants.bankNameLabelText
        saveButton.setTitle("Kaydet", for: .normal)
        nameTextField.placeholder = SaveIbanConstants.nameTextFieldPlaceholder
        ibanTextField.placeholder = SaveIbanConstants.ibanTextFieldPlaceholder
        bankNameTextField.placeholder = SaveIbanConstants.bankNameTextFieldPlaceholder
        ibanList = viewModel.getIbanList() ?? []
        setNavigationTitle(title: "IBAN Kaydet")
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.selectRow(0, inComponent: 0, animated: false)
        otherTextField.isHidden = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        bankNameTextField.delegate = self
        bankNameTextField.inputView = pickerView
    }

    @IBAction private func saveButtonClicked(_ sender: BaseButton) {
            guard let ibanText = ibanTextField.text, ibanText.isIban() else {
                showActionAlertCancel(errorTitle: IbanReaderManangerConstants.alertTitle, errorMessage: IbanReaderManangerConstants.alertMessage)
                return
            }
            
            let selectedBankName: String
            if let selectedOption = bankNameTextField.text, selectedOption == "Other" {
                // If "Other" is selected, use the text from otherTextField
                selectedBankName = otherTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            } else {
                // If any other option is selected, use the text from bankNameTextField
                selectedBankName = bankNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            }
            
            let name = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            
            if selectedBankName.isEmpty || name.isEmpty {
                showActionAlertCancel(errorTitle: "Eksik bilgi", errorMessage: "Banka adı ve isim alanları doldurulmalıdır.")
            } else {
                let newItem = IbanModel(ibanNumber: ibanText, bankName: selectedBankName, ibanName: name)
                ibanList.append(newItem)
                viewModel.saveIban(ibanList: ibanList)
                pushVC(key: .ibanList)
            }
    }
    // MARK: - UITextFieldDelegate

    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Dismiss the keyboard when Return is tapped
        textField.resignFirstResponder()
        return true
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - SAVEIBANVC EXTENSIONS
extension SaveIbanVC: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
   
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return banks.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return banks[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedOption = banks[row]
        bankNameTextField.text = selectedOption
        UIView.animate(withDuration: 0.3) {
            // Show/hide the additional text field with animation based on the selected option
            self.otherTextField?.alpha = (selectedOption == "Other") ? 1.0 : 0.0
            self.otherTextField?.transform = (selectedOption == "Other") ? .identity : CGAffineTransform(scaleX: 0.1, y: 0.1)
            // Keep the "Save" button at the fixed Y-coordinate
        }
        // Hide the other text field if the selected option is not "Other"
        otherTextField?.isHidden = (selectedOption != "Other")
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let selectedRow = banks.firstIndex(of: textField.text ?? "") {
            pickerView.selectRow(selectedRow, inComponent: 0, animated: false)
            // Show/hide the additional text field with animation based on the selected option
            UIView.animate(withDuration: 0.3) {
                self.otherTextField?.alpha = (self.banks[selectedRow] == "Other") ? 1.0 : 0.0
                self.otherTextField?.transform = (self.banks[selectedRow] == "Other") ? .identity : CGAffineTransform(scaleX: 0.1, y: 0.1)
            }
            // Hide the other text field if the selected option is not "Other"
            otherTextField?.isHidden = (self.banks[selectedRow] != "Other")
        }
    }
    
}
