//
//  UIViewControllerExtensions.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 5.12.2023.
//

import Foundation
import UIKit

enum ControllerKey: String {
    case ibanList = "IbanListVC"
    case saveIban = "SaveIbanVC"
    case main = "MainVC"
}

extension UIViewController {
    func pushVC(key: ControllerKey, animated: Bool = true)  {
        let viewController = UIViewController(nibName: key.rawValue, bundle: Bundle.main)
        navigationController?.pushViewController(viewController, animated: animated)
    }
    
    func popVC(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }
    
    func showActionAlertCancel(errorTitle: String, errorMessage: String) {
        let alertController = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Tamam", style: .cancel) { _ in
            print("Dismiss button tapped")
        }
        alertController.addAction(dismissAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
    
