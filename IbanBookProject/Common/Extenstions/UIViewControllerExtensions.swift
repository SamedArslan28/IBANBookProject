//
//  UIViewControllerExtensions.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 5.12.2023.
//

import Foundation
import UIKit

extension UIViewController {
    func showActionAlertCancel(errorTitle: String, errorMessage: String) {
        let alertController = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: CustomAlertsConstants.approval, style: .cancel) { _ in print("dismiss")}
        alertController.addAction(dismissAction)
        present(alertController, animated: true, completion: nil)
    }
}
