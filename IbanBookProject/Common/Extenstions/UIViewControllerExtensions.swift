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
        let alertConstants = CustomAlertsConstants()
        let alertController = UIAlertController(title: errorTitle.localized(), message: errorMessage.localized(), preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: alertConstants.approval.localized(), style: .cancel)
        alertController.addAction(dismissAction)
        present(alertController, animated: true, completion: nil)
    }
}
