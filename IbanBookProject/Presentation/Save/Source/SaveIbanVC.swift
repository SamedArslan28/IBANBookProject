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
    private var viewModel = SaveIbanVM()
    private var ibanList = [IbanModel]()
    lazy var pickerView: UIPickerView = {
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()

    // MARK: - IBOUTLETS

    @IBOutlet private weak var otherTextField: BaseTextField!
    @IBOutlet private weak var IBANNumberLabel: BaseLabel!
    @IBOutlet private weak var nameLabel: BaseLabel!
    @IBOutlet private weak var bankNameLabel: BaseLabel!
    @IBOutlet private weak var saveButton: BaseButton!
    @IBOutlet private weak var nameTextField: BaseTextField!
    @IBOutlet private weak var ibanTextField: BaseTextField!
    @IBOutlet private weak var bankNameTextField: BaseTextField!

    // MARK: - LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - PRIVATE FUNCTIONS
    
    private func setupUI() {
        if let data = data { ibanTextField.text = data as? String }
        view.setGradientBackground()
        saveButton.setTitle(SaveIbanConstants.saveButtonTitle.localized(), for: .normal)
        setNavigationTitle(title: SaveIbanConstants.saveNavigationTitle.localized())
        preparePickerView()
        prepareCustomBackButton()
        setupTextFields()
        prepareLabels()
        prepareLabels()
        ibanList = viewModel.getIbanList() ?? []
    }

    private func preparePickerView() {
        pickerView.selectRow(0, inComponent: 0, animated: true)
        pickerView.delegate = self
        pickerView.dataSource = self
    }

    private func prepareTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    private func prepareLabels() {
        IBANNumberLabel.text = SaveIbanConstants.ibanNumberLabelText.localized()
        nameLabel.text = SaveIbanConstants.fullNameLabelText.localized()
        bankNameLabel.text = SaveIbanConstants.bankNameLabelText.localized()
    }

    private func setupTextFields() {
        ibanTextField.autocapitalizationType = .allCharacters
        ibanTextField.text = "TR330006100519786457841326".localized()
        bankNameTextField.inputView = pickerView
        otherTextField.isHidden = true
        bankNameTextField.delegate = self
        nameTextField.placeholder = SaveIbanConstants.nameTextFieldPlaceholder.localized()
        ibanTextField.placeholder = SaveIbanConstants.ibanTextFieldPlaceholder.localized()
        bankNameTextField.placeholder = SaveIbanConstants.bankNameTextFieldPlaceholder.localized()
    }

    private func prepareCustomBackButton() {
        let customBackButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"),
                                               style: .plain,
                                               target: self,
                                               action: #selector(popToMainVC))
        customBackButton.customView?.isUserInteractionEnabled = true
        navigationItem.leftBarButtonItem = customBackButton
    }

    // MARK: - PRIVATEFUNCTIONS

    @objc private func popToMainVC() {
        popVC(animated: true)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - IBACTIONS
    // TODO: - DoRefactor

    @IBAction private func saveButtonClicked(_ sender: BaseButton) {
        guard validateIbanText() else { return }

        let ibanWithoutSpaces = viewModel.formatIban(ibanTextField.text!)
        let formattedIban = viewModel.formatIbanWithSpaces(ibanWithoutSpaces)
        let selectedBankName = determineBankName()
        let name = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        guard validateBankNameAndName(selectedBankName, name) else { return }

        let newItem = IbanModel(ibanNumber: formattedIban, bankName: selectedBankName, ibanName: name)
        viewModel.saveIban(newItem)
        pushVC(key: .ibanList)
    }

    private func validateIbanText() -> Bool {
        guard let ibanText = ibanTextField.text, ibanText.isIban() else {
            showActionAlertCancel(errorTitle: "missingInfoKey".localized(), errorMessage: "notFoundKey".localized())
            return false
        }
        return true
    }

    private func determineBankName() -> String {
        let selectedOption = bankNameTextField.text ?? ""
        if selectedOption == lastOption {
            return otherTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        }
        return selectedOption.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func validateBankNameAndName(_ bankName: String, _ name: String) -> Bool {
        if bankName.isEmpty || name.isEmpty {
            showActionAlertCancel(errorTitle: "missingInfoKey".localized(), errorMessage: "bankNameInfoKey".localized())
            return false
        }
        return true
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
