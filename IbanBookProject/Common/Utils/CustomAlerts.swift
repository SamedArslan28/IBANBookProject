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
        let dismissAction = UIAlertAction(title: CustomAlertsConstants.approval, style: .cancel) { _ in
           
        }
        alertController.addAction(dismissAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    func showImagePickerAlert(viewController: UIViewController) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = (viewController.self as? any UIImagePickerControllerDelegate & UINavigationControllerDelegate)
        let alert = UIAlertController(title: CustomAlertsConstants.imagePickerTitle, message:CustomAlertsConstants.imagePickerMessage , preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: CustomAlertsConstants.cameraPicker, style: .default , handler:{  _ in
            imagePicker.sourceType = .camera
            viewController.present(imagePicker, animated: true, completion: nil)
}))
        alert.addAction(UIAlertAction(title: CustomAlertsConstants.photoLibraryPicker, style: .default , handler:{ _ in
            imagePicker.sourceType = .photoLibrary
            viewController.present(imagePicker, animated: true, completion: nil)
            
        }))
        alert.addAction(UIAlertAction(title: CustomAlertsConstants.cancel, style: .cancel))
        viewController.present(alert, animated: true, completion: nil)
    }
}

