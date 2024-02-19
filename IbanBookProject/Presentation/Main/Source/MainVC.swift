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
    let alertConstants = CustomAlertsConstants()
    
    // MARK: - LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.setGradientBackground()
        setupImagePicker()
        setupUI()
    }
    
    // MARK: - PRIVATE FUNCTIONS
    
    private func setupImagePicker() {
        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self
        imagePicker?.allowsEditing = true
    }
    
    private func setupUI(){
        let mainconstant = MainConstants()
        descriptionLabel.text = mainconstant.descriptionLabelText.localized()
        saveIban.setTitle(mainconstant.saveIbanButtonTitle.localized(), for: .normal)
        ibanList.setTitle(mainconstant.ibanListButtonTitle.localized(), for: .normal)
        readIBANClicked.setTitle(mainconstant.readIbanButtonTitle.localized(), for: .normal)
        setNavigationColor()
        setNavigationTitleColor()
        navigationItem.hidesBackButton = false
        navigationController?.setToolbarHidden(true, animated: true)
        let settingsButton = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(pushSettingsVC))
        settingsButton.tintColor = .themeColor
        navigationItem.rightBarButtonItem = settingsButton
    }
    
    private func showImagePickerAlert() {
        let alert = UIAlertController(title: alertConstants.imagePickerTitle.localized(),
                                      message: alertConstants.imagePickerMessage.localized(),
                                      preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: alertConstants.cameraPicker.localized(),
                                      style: .default ,
                                      handler: { [weak self] _ in
            self?.showImagePicker(sourceType: .camera)
        }))
        alert.addAction(UIAlertAction(title: alertConstants.photoLibraryPicker.localized(),
                                      style: .default ,
                                      handler: { [weak self] _ in
            self?.showImagePicker(sourceType: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: alertConstants.cancel.localized(), style: .cancel))
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
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        let reader = IbanReaderManager()
        reader.processImage(image: image){ [weak self] items in
            if items.isEmpty {
                self?.showActionAlertCancel(errorTitle: (self?.alertConstants.errorTitle.localized())!, errorMessage: (self?.alertConstants.errorMessage.localized())!)
            } else if items.count > 1 {
                let actionSheet = UIAlertController(title: self!.alertConstants.selectItem.localized(), message: nil, preferredStyle: .actionSheet)
                for item in items {
                    let action = UIAlertAction(title: "\(item)", style: .default) { _ in
                        self?.pushVC(key: .saveIban, data: item)
                    }
                    actionSheet.addAction(action)
                }
                let cancelAction = UIAlertAction(title: self!.alertConstants.cancel.localized(), style: .cancel, handler: nil)
                actionSheet.addAction(cancelAction)
                self?.present(actionSheet, animated: true, completion: nil)
            } else {
                self?.pushVC(key: .saveIban, data: items.first)
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
}
