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
        if let pickedImage = info[.originalImage] as? UIImage {
            let visionImage = VisionImage(image: pickedImage)
            let latinOptions = TextRecognizerOptions()
            let latinTextRecognizer = TextRecognizer.textRecognizer(options:latinOptions)
            var ibanFound = false
            latinTextRecognizer.process(visionImage) { result, error in
                guard error == nil, let result = result else {
                    print("Error recognizing text: \(error?.localizedDescription ?? "")")
                    return
                }
                guard !result.blocks.isEmpty else {
                    self.showActionAlertCancel(errorTitle: "Metin bulunamadı", errorMessage: "Okunacak bir metin bulunamadı.")
                    return
                }
                for block in result.blocks {
                    for line in block.lines {
                        let lineText = line.text
                        if lineText.isIban() {
                            let foundIban = lineText.extractIban()
                            print(foundIban!)
                            ibanFound = true
                        }
                    }
                }
                if !ibanFound {
                    self.showActionAlertCancel(errorTitle: "IBAN bulunamadi", errorMessage: "Metin içerisinde IBAN bulunamdı.")
                }
            }
            picker.dismiss(animated: true, completion: nil)
        }
        
    }
    func handlePhotoSourceSelection(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        switch sourceType {
        case .camera:
            imagePicker.sourceType = .camera
        case .photoLibrary:
            imagePicker.sourceType = .photoLibrary
        case .savedPhotosAlbum:
            break
        default:
            break
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    func showPhotoPickerAction() {
        let alert = UIAlertController(title: "Kaynak Seciniz", message: "Iban nereden okunacak ?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Kamera", style: .default , handler:{ [weak self] _ in
            self?.handlePhotoSourceSelection(sourceType: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Fotograflar", style: .default , handler:{ [weak self] _ in
            self?.handlePhotoSourceSelection(sourceType: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "Vazgeç", style: .cancel))
        
        // Present the action sheet
        present(alert, animated: true, completion: nil)
    }
}
