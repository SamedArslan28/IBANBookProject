//
//  ImagePickerExstenstions.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 30.11.2023.
//

import Foundation
import UIKit
import MLKitVision
import MLKitTextRecognition



extension MainVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else{ return }
        IbanReaderManager.shared.processImage(image: image, viewController: self)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func showPhotoPickerAction() {
        CustomAlerts.shared.showImagePickerAlert(viewController: self)
    }
}
