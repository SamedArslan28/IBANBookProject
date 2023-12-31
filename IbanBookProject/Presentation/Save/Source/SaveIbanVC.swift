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
    let banks = [
        "Halkbank",
        "Vakıfbank",
        "Ziraat Bankası",
        "Akbank",
        "Türkiye İş Bankası",
        "Yapı Kredi",
        "Alternatif Bank",
        "DenizBank",
        "Deutsche Bank",
        "Garanti BBVA",
        "HSBC",
        "ING",
        "Odeabank",
        "QNB Finansbank",
        "Rabobank",
        "TEB",
        "JPMorgan Chase Bank",
        "Diğer"]
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()

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

        saveButton.setTitle("Kaydet", for: .normal)
        setNavigationTitle(title: "IBAN Kaydet")
        if let data = data{
            ibanTextField.text = data as? String
        }
        IBANNumberLabel.text = SaveIbanConstants.ibanNumberLabelText
        nameLabel.text = SaveIbanConstants.fullNameLabelText
        bankNameLabel.text = SaveIbanConstants.bankNameLabelText
        nameTextField.placeholder = SaveIbanConstants.nameTextFieldPlaceholder
        ibanTextField.placeholder = SaveIbanConstants.ibanTextFieldPlaceholder
        bankNameTextField.placeholder = SaveIbanConstants.bankNameTextFieldPlaceholder
        ibanList = viewModel.getIbanList() ?? []
        pickerView.selectRow(0, inComponent: 0, animated: false)
        otherTextField.isHidden = true
        bankNameTextField.delegate = self
        pickerView.delegate = self
        pickerView.dataSource = self
        bankNameTextField.inputView = pickerView
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @IBAction private func saveButtonClicked(_ sender: BaseButton) {
            guard let ibanText = ibanTextField.text, ibanText.isIban() else {
                showActionAlertCancel(errorTitle: "Eksik bilgi", errorMessage: "Butun alanlar doldurulmalidir.")
                return
            }
            let selectedBankName: String
            if let selectedOption = bankNameTextField.text, selectedOption == "Diğer" {
                selectedBankName = otherTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            } else {
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

// MARK: - PICKERVIEW EXTENSIONS

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
        UIView.animate(withDuration: 0.5) {
            self.otherTextField?.alpha = (selectedOption == "Diğer") ? 1.0 : 0.0
            self.otherTextField?.transform = (selectedOption == "Diğer") ? .identity : CGAffineTransform(scaleX: 0.1, y: 0.1)
        }
        otherTextField?.isHidden = (selectedOption != "Diğer")
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let selectedRow = banks.firstIndex(of: textField.text ?? "") {
            pickerView.selectRow(selectedRow, inComponent: 0, animated: false)
            UIView.animate(withDuration: 0.5) {
                self.otherTextField?.alpha = (self.banks[selectedRow] == "Diğer") ? 1.0 : 0.0
                self.otherTextField?.transform = (self.banks[selectedRow] == "Diğer") ? .identity : CGAffineTransform(scaleX: 0.1, y: 0.1)
            }completion: { _ in
                UIView.animate(withDuration: 0.5) {
                    self.otherTextField?.isHidden = (self.banks[selectedRow] != "Diğer")
                }
            }
        }
    }
    
    
}
