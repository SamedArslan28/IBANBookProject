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
        IbanReaderManager.shared.processImage(image: info[.originalImage] as! UIImage, viewController: self)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func showPhotoPickerAction() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        let alert = UIAlertController(title: "Kaynak Seciniz", message: "Iban nereden okunacak ?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Kamera", style: .default , handler:{  _ in
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)

//            self?.handlePhotoSourceSelection(sourceType: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Fotograflar", style: .default , handler:{  _ in
//            self?.handlePhotoSourceSelection(sourceType: .photoLibrary)
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)

        }))
        alert.addAction(UIAlertAction(title: "Vazgeç", style: .cancel))
        present(alert, animated: true, completion: nil)
    }
}
