//
//  SettingsVC.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 7.02.2024.
//

import UIKit

final class SettingsVC: BaseVC, Navigable {
    
    // MARK: - IBOUTLETS
    
    @IBOutlet weak var copyAllButton: BaseButton!
    @IBOutlet weak var englishSwitch: UISwitch!
    @IBOutlet weak var messageLabel: BaseLabel!
    @IBOutlet weak var englishLabel: BaseLabel!
    
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - PRIVATE FUCNTIONS
    private func setupUI(){
        view.setGradientBackground()
        copyAllButton.setTitle("Kaydet".localized(), for: .normal)
        englishSwitch.isOn = false
        englishLabel.text = "English"
        let customBackButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"),
                                               style: .plain,
                                               target: self,
                                               action: #selector(popToMainVC))
        customBackButton.customView?.isUserInteractionEnabled = true
        navigationItem.leftBarButtonItem = customBackButton
        messageLabel.text = "Değişiklikleri kaydedin.".localized()
        messageLabel.layer.opacity = 0.8
        messageLabel.isEnabled = false
        
    }
    
    @objc private func popToMainVC() {
        if (navigationController?.viewControllers.count)! > 2 {
            popToMain()
        }else {
            popVC(animated: true)
        }
        
    }
    
    @IBAction private func saveButtonTapeed(_ sender: BaseButton) {
        
        
    }
}
