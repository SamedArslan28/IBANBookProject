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
        let dismissAction = UIAlertAction(title: CustomAlertsConstants.approval, style: .cancel) { _ in
           print("dismiss")
        }
        alertController.addAction(dismissAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func showImagePickerAlert() {
        DispatchQueue.main.async {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = (self as? any UIImagePickerControllerDelegate & UINavigationControllerDelegate)
            let alert = UIAlertController(title: CustomAlertsConstants.imagePickerTitle,
                                          message: CustomAlertsConstants.imagePickerMessage,
                                          preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: CustomAlertsConstants.cameraPicker,
                                          style: .default ,
                                          handler: { [weak self] _ in
                imagePicker.sourceType = .camera
                self?.present(imagePicker, animated: true, completion: nil) }))
            alert.addAction(UIAlertAction(title: CustomAlertsConstants.photoLibraryPicker,
                                          style: .default ,
                                          handler: { [weak self] _ in
                imagePicker.sourceType = .photoLibrary
                self?.present(imagePicker, animated: true, completion: nil) }))
            alert.addAction(UIAlertAction(title: CustomAlertsConstants.cancel, style: .cancel))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
