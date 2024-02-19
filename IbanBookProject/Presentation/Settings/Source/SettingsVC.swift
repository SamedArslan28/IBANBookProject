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
    
    private func setupUI() {
        view.setGradientBackground()
        englishSwitch.setOn(CacheManager.shared.getString(key: "languageCode") == "en", animated: false) 
        copyAllButton.setTitle("saveKey".localized(), for: .normal)
        englishLabel.text = "English"
        messageLabel.text = "saveChangesKey".localized()
        messageLabel.isEnabled = false
        let customBackButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"),
                                               style: .plain,
                                               target: self,
                                               action: #selector(popToMainVC))
        customBackButton.customView?.isUserInteractionEnabled = true
        navigationItem.leftBarButtonItem = customBackButton
    }
    
    @objc private func popToMainVC() {
        guard let navigationControllers =  navigationController?.viewControllers else { return }
        if navigationControllers.count > 2 {
            popToMain()
        } else {
            popVC(animated: true)
        }
    }
    
    @IBAction private func saveButtonTapeed(_ sender: BaseButton) {
        restartApplication()
    }
    
    private func reloadRootViewController() {
        let isEnglish = englishSwitch.isOn
        let languageCode = isEnglish ? "en" : "tr"
        CacheManager.shared.setObject(languageCode, key: "languageCode")
//        CacheManager.shared.setObject([languageCode], key: "AppleLanguages")
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = windowScene.windows.first {
                guard let snapshotView = window.snapshotView(afterScreenUpdates: true) else { return }
                guard let viewController = ControllerFactory.createVC(with: .main) else { return }
                let newViewController = viewController
                let newNavController = UINavigationController(rootViewController: newViewController)
                window.rootViewController = newNavController
                window.addSubview(snapshotView)
                UIView.transition(with: snapshotView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    snapshotView.alpha = 0
                }, completion: { _ in
                    snapshotView.removeFromSuperview()
                })
            }
        }
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
