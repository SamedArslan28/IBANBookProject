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
    var givenData:IbanDataModel?

    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
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
        givenData = data as? IbanDataModel
        setupUI()
        setupGestures()
        ibanList = viewModel.getIbanList() ?? []
    }

    // MARK: - SETUP FUNCTIONS

    private func setupUI() {
        super.setBackground()
        setNavigationColor()
        setNavigationTitleColor()
        setupNavigation()
        setupTextFields()
        setupLabels()
        setupSaveButton()
    }

    private func setupNavigation() {
        setNavigationTitle(title: SaveIbanConstants.saveNavigationTitle.localized())
        setupCustomBackButton()
    }

    private func setupCustomBackButton() {
        let customBackButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"),
                                               style: .plain,
                                               target: self,
                                               action: #selector(popToMainVC))

        navigationItem.leftBarButtonItem = customBackButton
    }

    private func setupTextFields() {
        nameTextField.placeholder = SaveIbanConstants.nameTextFieldPlaceholder.localized()
        ibanTextField.placeholder = SaveIbanConstants.ibanTextFieldPlaceholder.localized()
        bankNameTextField.placeholder = SaveIbanConstants.bankNameTextFieldPlaceholder.localized()
        ibanTextField.autocapitalizationType = .allCharacters
        bankNameTextField.delegate = self
        bankNameTextField.inputView = pickerView
        otherTextField.isHidden = true

        guard let givenData else { return }
        ibanTextField.text = givenData.iban
        nameTextField.text = givenData.name
        bankNameTextField.text = givenData.bankName
    }

    private func setupLabels() {
        IBANNumberLabel.text = SaveIbanConstants.ibanNumberLabelText.localized()
        nameLabel.text = SaveIbanConstants.fullNameLabelText.localized()
        bankNameLabel.text = SaveIbanConstants.bankNameLabelText.localized()
    }

    private func setupSaveButton() {
        saveButton.setTitle(SaveIbanConstants.saveButtonTitle.localized(), for: .normal)
    }

    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    // MARK: - ACTIONS

    @objc private func popToMainVC() {
        if (navigationController?.viewControllers.count ?? 0) > 2 {
            popToMain()
        } else {
            popVC(animated: true)
        }
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction private func saveButtonClicked(_ sender: BaseButton) {
        guard validateInput() else {
            showMissingInfoAlert()
            return
        }
        saveIban()
        pushVC(key: .ibanList)
    }

    // MARK: - PRIVATE FUNCTIONS

    private func validateInput() -> Bool {
        guard let ibanText = ibanTextField.text, ibanText.isIban(),
              let selectedBankName = bankNameTextField.text, !selectedBankName.isEmpty,
              let name = nameTextField.text, !name.isEmpty else {
            return false
        }
        return true
    }

    private func saveIban() {
        let formattedIban = viewModel.formatIban(ibanTextField.text ?? "")
        let selectedBankName = bankNameTextField.text == lastOption ? otherTextField.text ?? "" : bankNameTextField.text ?? ""
        let name = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        let newItem = IbanModel(ibanNumber: formattedIban, bankName: selectedBankName, ibanName: name)
        ibanList.append(newItem)
        viewModel.saveIban(ibanList: ibanList)
    }

    private func showMissingInfoAlert() {
        showActionAlertCancel(errorTitle: "missingInfoKey".localized(),
                              errorMessage: "notFoundKey".localized())
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
