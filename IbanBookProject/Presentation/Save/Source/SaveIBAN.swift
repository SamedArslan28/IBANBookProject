//
//  SaveIBAN.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 6.11.2023.
//

import Foundation
import UIKit

final class SaveIBAN: BaseVC {

    // MARK: - Outlets

    @IBOutlet private weak var IBANNumberLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet weak var bankNameLabel: UILabel!
    @IBOutlet private weak var saveButton: BaseButton!
    @IBOutlet weak var nameTextField: BaseTextField!
    @IBOutlet weak var ibanTextField: BaseTextField!

    @IBOutlet weak var bankNameTextField: BaseTextField!
   

    @IBAction func saveButtonClicked(_ sender: BaseButton) {
        
        
    }
    // MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationTitle(title: "IBAN Kaydet")

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        IBANNumberLabel.text = "IBAN"
        nameLabel.text = "Ad Soyad"
        bankNameLabel.text = "Banka Adı"
        saveButton.setTitle("Kaydet", for: .normal)
        nameTextField.placeholder = "Ad Soyad"
        ibanTextField.placeholder = "TR00 0000 0000 0000 0000 0000 00"
        bankNameTextField.placeholder = "Banka Adı"


    }

}
