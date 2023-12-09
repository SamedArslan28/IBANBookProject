//
//  CustomAlerts.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 9.12.2023.
//

import Foundation
import UIKit

final class CustomAlerts {
    static let shared = CustomAlerts()
    private init(){ }
    
    func showActionAlertCancel(errorTitle: String, errorMessage: String, viewController: UIViewController) {
        let alertController = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Tamam", style: .cancel) { _ in
            print("Dismiss button tapped")
        }
        alertController.addAction(dismissAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
}

