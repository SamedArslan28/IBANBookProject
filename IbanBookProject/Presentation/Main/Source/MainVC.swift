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

    lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        return picker
    }()

    // MARK: - LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }

    // MARK: - PRIVATE FUNCTIONS

    private func setupUI(){
        descriptionLabel.text = MainConstants.descriptionLabelText
        saveIban.setTitle(MainConstants.saveIbanButtonTitle, for: .normal)
        ibanList.setTitle(MainConstants.ibanListButtonTitle, for: .normal)
        readIBANClicked.setTitle(MainConstants.readIbanButtonTitle, for: .normal)
        setNavigationColor()
        imagePicker.delegate = self
        navigationItem.hidesBackButton = false
        navigationController?.setToolbarHidden(true, animated: true)
    }
    
    private func showImagePickerAlert() {
        let alert = UIAlertController(title: CustomAlertsConstants.imagePickerTitle,
                                      message: CustomAlertsConstants.imagePickerMessage,
                                      preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: CustomAlertsConstants.cameraPicker,
                                      style: .default ,
                                      handler: { [weak self] _ in
            self?.showImagePicker(sourceType: .camera)
        }))
        alert.addAction(UIAlertAction(title: CustomAlertsConstants.photoLibraryPicker,
                                      style: .default ,
                                      handler: { [weak self] _ in
            self?.showImagePicker(sourceType: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: CustomAlertsConstants.cancel, style: .cancel))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func showImagePicker(sourceType: UIImagePickerController.SourceType) {
        self.imagePicker.sourceType = sourceType
        DispatchQueue.main.async {
            self.present(self.imagePicker, animated: true, completion: nil)
        }
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
        guard let image = info[.originalImage] as? UIImage else { return }
        let reader = IbanReaderManager()
        reader.processImage(image: image){ [weak self] items in
            if items.isEmpty {
                self?.showActionAlertCancel(errorTitle: "Iban Bulunamadı.", errorMessage: "Lutfen baska bir fotograf seciniz.")
            } else if items.count > 1 {
                let actionSheet = UIAlertController(title: "Choose an item", message: nil, preferredStyle: .actionSheet)
                for item in items {
                    let action = UIAlertAction(title: "\(item)", style: .default) { _ in
                        // Push the view controller with the selected item's data
                        self?.pushVC(key: .saveIban, data: item)
                    }
                    actionSheet.addAction(action)
                }
                // Add a cancel action
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                actionSheet.addAction(cancelAction)
                // Present the action sheet
                self?.present(actionSheet, animated: true, completion: nil)
            }
            else{
                self?.pushVC(key: .saveIban, data:items.first)
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }

}
