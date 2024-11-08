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
        setNavigationColor()
        setNavigationTitleColor()
    }
    
    // MARK: - PRIVATE FUCNTIONS
    
    private func setupUI() {
        setBackground()
        prepareComponents()
        prepareCustomBackButton()
    }

    private func prepareCustomBackButton() {
        let customBackButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"),
                                               style: .plain,
                                               target: self,
                                               action: #selector(popToMainVC))
        
        navigationItem.leftBarButtonItem = customBackButton
    }

    private func prepareComponents() {
        englishSwitch.setOn(CacheManager.shared.getString(key: "languageCode") == "en", animated: false)
        copyAllButton.setTitle("saveKey".localized(), for: .normal)
        englishLabel.text = "English"
        messageLabel.text = "saveChangesKey".localized()
        messageLabel.isEnabled = false
    }

    @objc private func popToMainVC() {
        popVC(animated: true)
    }
    
    @IBAction private func saveButtonTapeed(_ sender: BaseButton) {
        restartApplication()
    }
    
    func restartApplication() {
        let isEnglish = englishSwitch.isOn
        let languageCode = isEnglish ? "en" : "tr"
        CacheManager.shared.setObject(languageCode, key: "languageCode")
        guard let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first else { return }
        guard let viewController = ControllerFactory.createVC(with: .main) else { return }
        let navCtrl = UINavigationController(rootViewController: viewController)
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = navCtrl
        })
    }
}
