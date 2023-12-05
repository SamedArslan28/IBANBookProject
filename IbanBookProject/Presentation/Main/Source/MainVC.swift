//
//  ViewController.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 15.08.2023.
//

import UIKit

final class MainVC: BaseVC {
    
    // MARK: - OUTLETS
    @IBOutlet weak var descriptionLabel: BaseLabel!
    @IBOutlet weak var saveIban: BaseButton!
    @IBOutlet weak var ibanList: BaseButton!
    @IBOutlet weak var readIBANClicked: BaseButton!
    
    // MARK: - PROPERTIES
    let imagePickerItem = UIImagePickerController()
    let viewModel = MainMV()
    var foundIbans = [String]()
    
    // MARK: - LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagePickerItem.delegate = self
        setupUI()
        prepareUI()
    }
    
    // MARK: - PRIVATE FUNCTIONS
    
    private func setupUI(){
        descriptionLabel.text = viewModel.descriptionLabelText
        saveIban.setTitle(viewModel.saveIbanButtonTitle, for: .normal)
        ibanList.setTitle(viewModel.ibanListButtonTitle, for: .normal)
        readIBANClicked.setTitle(viewModel.readIbanButtonTitle, for: .normal)
    }
    
    private func prepareUI(){
        setNavigationColor()
        navigationItem.hidesBackButton = false
    }
    
    // MARK: - IBACTIONS
    
    @IBAction private func ibanListTapped(_ sender: Any) {
        let viewController = IbanListVC(nibName: "IbanListVC", bundle: Bundle.main)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction private func saveIbanTapped(_ sender: Any) {
        let viewController = SaveIbanVC(nibName: "SaveIbanVC", bundle: Bundle.main)
        navigationController?.pushViewController(viewController, animated: true)
    }

    @IBAction private func selectPhotoSource(_ sender: BaseButton) {
        let alert = UIAlertController(title: "Kaynak Seciniz", message: "Iban nereden okunacak ?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Kamera", style: .default , handler:{ _ in
            self.viewModel.handlePhotoSourceSelection(sourceType: .camera, viewController: self)
        }))
        alert.addAction(UIAlertAction(title: "Fotograflar", style: .default , handler:{ _ in
            self.viewModel.handlePhotoSourceSelection(sourceType: .photoLibrary, viewController: self)
        }))
        alert.addAction(UIAlertAction(title: "Vazgeç", style: .cancel))
        present(alert, animated: true)
    }
}



