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
        let viewController = IbanListVC(nibName: "IbanListVC", bundle: Bundle.main)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction private func saveIbanTapped(_ sender: Any) {
        let viewController = SaveIbanVC(nibName: "SaveIbanVC", bundle: Bundle.main)
        navigationController?.pushViewController(viewController, animated: true)
    }

    @IBAction private func selectPhotoSource(_ sender: BaseButton) {
        self.showPhotoPickerAction()
    }
}
