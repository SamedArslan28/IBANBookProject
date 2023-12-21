//
//  ViewController.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 15.08.2023.
//

import UIKit
import MLKitVision
import MLKitTextRecognition

final class MainVC: BaseVC,Coordinating {
    
    var coordinator: Coordinator?
    
    // MARK: - OUTLETS
    @IBOutlet weak var descriptionLabel: BaseLabel!
    @IBOutlet weak var saveIban: BaseButton!
    @IBOutlet weak var ibanList: BaseButton!
    @IBOutlet weak var readIBANClicked: BaseButton!
    
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
        navigationItem.hidesBackButton = false
        navigationController?.setToolbarHidden(true, animated: true)
    }
    
    // MARK: - IBACTIONS
    
    @IBAction private func ibanListTapped(_ sender: Any) {
        coordinator?.eventOccured(with: .IbanList)
    }
    
    @IBAction private func saveIbanTapped(_ sender: Any) {
        coordinator?.eventOccured(with: .SaveIban)
    }
    
    @IBAction private func selectPhotoSource(_ sender: BaseButton) {
        DispatchQueue.main.async {
            self.showPhotoPickerAction()
        }
    }
}

extension MainVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        IbanReaderManager.shared.processImage(image: image)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func showPhotoPickerAction() {
        showImagePickerAlert()
    }
}
