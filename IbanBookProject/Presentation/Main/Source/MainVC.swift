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
        setupUI()
       
    }

    // MARK: - FUNCTIONS
    @IBAction func selectPhotoSource(_ sender: BaseButton) {

        let alert = UIAlertController(title: "Kaynak Seciniz", message: "Iban nereden okunacak ?", preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Kamera", style: .default , handler:{ _ in
            self.viewModel.handlePhotoSourceSelection(sourceType: .camera, viewController: self)
        }))

        alert.addAction(UIAlertAction(title: "Fotograflar", style: .default , handler:{ _ in
            self.viewModel.handlePhotoSourceSelection(sourceType: .photoLibrary, viewController: self)
        }))

        alert.addAction(UIAlertAction(title: "Vazgeç", style: .cancel))
        
        self.present(alert, animated: true)
    }
    
    private func setupUI(){
        descriptionLabel.text = viewModel.descriptionLabelText
        saveIban.setTitle(viewModel.saveIbanButtonTitle, for: .normal)
        ibanList.setTitle(viewModel.ibanListButtonTitle, for: .normal)
        readIBANClicked.setTitle(viewModel.readIbanButtonTitle, for: .normal)
        setNavigationColor()
        imagePickerItem.delegate = self
        navigationItem.hidesBackButton = false
    }
}



