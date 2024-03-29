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
    
    private let lastOption = "othersKey".localized()
    private let saveConstants = SaveIbanConstants()
    private var viewModel = SaveIbanVM()
    private var ibanList = [IbanModel]()
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    // MARK: - Outlets
    
    @IBOutlet private weak var otherTextField: BaseTextField!
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
    
    // MARK: - PRIVATE FUNCTIONS
    
    private func setupUI() {
        view.setGradientBackground()
        saveButton.setTitle(saveConstants.saveButtonTitle.localized(), for: .normal)
        setNavigationTitle(title: saveConstants.saveNavigationTitle.localized())
        if let data = data { ibanTextField.text = data as? String }
        IBANNumberLabel.text = saveConstants.ibanNumberLabelText.localized()
        nameLabel.text = saveConstants.fullNameLabelText.localized()
        bankNameLabel.text = saveConstants.bankNameLabelText.localized()
        nameTextField.placeholder = saveConstants.nameTextFieldPlaceholder.localized()
        ibanTextField.placeholder = saveConstants.ibanTextFieldPlaceholder.localized()
        bankNameTextField.placeholder = saveConstants.bankNameTextFieldPlaceholder.localized()
        ibanList = viewModel.getIbanList() ?? []
        pickerView.selectRow(0, inComponent: 0, animated: true)
        otherTextField.isHidden = true
        bankNameTextField.delegate = self
        pickerView.delegate = self
        pickerView.dataSource = self
        bankNameTextField.inputView = pickerView
        ibanTextField.text = "TR330006100519786457841326".localized()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        ibanTextField.autocapitalizationType = .allCharacters
        let customBackButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"),
                                               style: .plain,
                                               target: self,
                                               action: #selector(popToMainVC))
        customBackButton.customView?.isUserInteractionEnabled = true
        navigationItem.leftBarButtonItem = customBackButton
    }
    
    // MARK: - PRIVATEFUNCTIONS
    
    @objc private func popToMainVC() {
        if (navigationController?.viewControllers.count)! > 2 {
            popToMain()
        } else {
            popVC(animated: true)
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - IBACTIONS
    
    @IBAction private func saveButtonClicked(_ sender: BaseButton) {
        guard let ibanText = ibanTextField.text, ibanText.isIban() else {
            showActionAlertCancel(errorTitle: "missingInfoKey".localized(), errorMessage: "notFoundKey".localized())
            return
        }
        let selectedBankName: String
        let ibanWithoutSpaces = ibanText.replacingOccurrences(of: "\\s", with: "", options: .regularExpression)
        let formattedIban = ibanWithoutSpaces.replacingOccurrences(of: "(\\d{2})(\\d{4})(\\d{4})(\\d{4})(\\d{4})(\\d{4})(\\d{2})",
                                                                   with: "$1 $2 $3 $4 $5 $6 $7",
                                                                   options: .regularExpression)
        if let selectedOption = bankNameTextField.text, selectedOption == lastOption {
            selectedBankName = otherTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        } else {
            selectedBankName = bankNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        }
        let name = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if selectedBankName.isEmpty || name.isEmpty {
            showActionAlertCancel(errorTitle: "missingInfoKey".localized(),
                                  errorMessage: "bankNameInfoKey".localized())
        } else {
            let newItem = IbanModel(ibanNumber: formattedIban, bankName: selectedBankName, ibanName: name)
            ibanList.append(newItem)
            viewModel.saveIban(ibanList: ibanList)
            pushVC(key: .ibanList)
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - PICKERVIEW EXTENSIONS

extension SaveIbanVC: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.banks.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.banks.get(at: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedOption = viewModel.banks[row]
        bankNameTextField.text = selectedOption
        UIView.animate(withDuration: 0.5) {
            self.otherTextField?.alpha = (selectedOption == self.lastOption) ? 1.0 : 0.0
            self.otherTextField?.transform = (selectedOption == self.lastOption) ? .identity : CGAffineTransform(scaleX: 0.1, y: 0.1)
        }
        otherTextField?.isHidden = (selectedOption != lastOption)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == bankNameTextField {
            let selectedRow = 0
            pickerView.selectRow(selectedRow, inComponent: 0, animated: false)
            let selectedOption = viewModel.banks[selectedRow]
            UIView.transition(with: bankNameTextField, duration: 0.5, options: .transitionCrossDissolve, animations: {
                textField.text = selectedOption
            }, completion: nil)
            otherTextField?.isHidden = (selectedOption != lastOption)
        }
    }
}
