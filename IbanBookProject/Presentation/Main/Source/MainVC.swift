//
//  ViewController.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 15.08.2023.
//

import UIKit
import MLKitVision
import MLKitTextRecognition

final class MainVC: BaseVC, Navigable {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var descriptionLabel: BaseLabel!
    @IBOutlet weak var saveIban: BaseButton!
    @IBOutlet weak var ibanList: BaseButton!
    @IBOutlet weak var readIBANClicked: BaseButton!
    
    // MARK: - PROPERTIES
    
    var imagePicker: UIImagePickerController?
    
    // MARK: - LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        setupUI()
    }
    
    // MARK: - PRIVATE FUNCTIONS

    private func setupUI(){
        preapreComponents()
        setNavigationColor()
        setNavigationTitleColor()
        prepareNavBar()
        setupImagePicker()
    }

    private func setupImagePicker() {
        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self
        imagePicker?.allowsEditing = true
    }
    
    private func prepareNavBar() {
        guard let navigationController else { return }
        navigationItem.hidesBackButton = false
        navigationController.setToolbarHidden(true, animated: true)
        let settingsButton = UIBarButtonItem(image: UIImage(systemName: "gear"),
                                             style: .plain, target: self,
                                             action: #selector(pushSettingsVC))
        settingsButton.tintColor = .themeColor
        navigationItem.rightBarButtonItem = settingsButton
    }

    private func preapreComponents() {
        descriptionLabel.text = MainConstants.descriptionLabelText.localized()
        saveIban.setTitle(MainConstants.saveIbanButtonTitle.localized(), for: .normal)
        ibanList.setTitle(MainConstants.ibanListButtonTitle.localized(), for: .normal)
        readIBANClicked.setTitle(MainConstants.readIbanButtonTitle.localized(), for: .normal)
    }

    private func showImagePickerAlert() {
        let alert = UIAlertController(title: CustomAlertsConstants.imagePickerTitle.localized(),
                                      message: CustomAlertsConstants.imagePickerMessage.localized(),
                                      preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: CustomAlertsConstants.cameraPicker.localized(),
                                      style: .default ,
                                      handler: { [weak self] _ in
            self?.showImagePicker(sourceType: .camera)
        }))
        alert.addAction(UIAlertAction(title: CustomAlertsConstants.photoLibraryPicker.localized(),
                                      style: .default ,
                                      handler: { [weak self] _ in
            self?.showImagePicker(sourceType: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: CustomAlertsConstants.cancel.localized(), style: .cancel))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func showImagePicker(sourceType: UIImagePickerController.SourceType) {
        guard let imagePicker else { return }
        imagePicker.sourceType = sourceType
        DispatchQueue.main.async {
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @objc func pushSettingsVC() {
        pushVC(key: .settings)
    }
    // MARK: - IBACTIONS
    
    @IBAction private func ibanListTapped(_ sender: Any) {
        pushVC(key: .ibanList)
    }
    
    @IBAction private func saveIbanTapped(_ sender: Any) {
        pushVC(key: .saveIban)
    }
    
    @IBAction private func selectPhotoSource(_ sender: BaseButton) {
        DispatchQueue.main.async { [weak self]  in
            self?.showImagePickerAlert()
        }
    }
}

// MARK: - TABLEVIEW EXTENSIONS

extension MainVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            picker.dismiss(animated: true, completion: nil)
            return
        }

        processPickedImage(image)
        picker.dismiss(animated: true, completion: nil)
    }

    private func processPickedImage(_ image: UIImage) {
        let reader: OCRManager = IbanReaderManager()
        reader.proccessImage(image: image) { [weak self] items in
            guard let self = self else { return }
            self.handleOCRResult(items)
        }
    }

    private func handleOCRResult(_ items: [String]) {
        if items.isEmpty {
            showErrorAlert()
        } else if items.count > 1 {
            presentActionSheet(for: items)
        } else {
            pushVC(key: .saveIban, data: items.first)
        }
    }

    private func showErrorAlert() {
        showActionAlertCancel(
            errorTitle: CustomAlertsConstants.errorTitle.localized(),
            errorMessage: CustomAlertsConstants.errorMessage.localized()
        )
    }

    private func presentActionSheet(for items: [String]) {
        let actionSheet = UIAlertController(
            title: CustomAlertsConstants.selectItem.localized(),
            message: nil,
            preferredStyle: .actionSheet
        )

        for item in items {
            let action = UIAlertAction(title: "\(item)", style: .default) { _ in
                self.pushVC(key: .saveIban, data: item)
            }
            actionSheet.addAction(action)
        }

        let cancelAction = UIAlertAction(
            title: CustomAlertsConstants.cancel.localized(),
            style: .cancel,
            handler: nil
        )
        actionSheet.addAction(cancelAction)

        present(actionSheet, animated: true, completion: nil)
    }
}

