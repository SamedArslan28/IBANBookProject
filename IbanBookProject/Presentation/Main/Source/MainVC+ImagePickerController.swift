//
//  MainVC+ImagePickerController.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 13.09.2024.
//

import UIKit
import PhotosUI

extension MainVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let result = results.first else { return }
        result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
            if let image = object as? UIImage {
                DispatchQueue.main.async {
                    self.processSelectedImage(image)
                }
            }
        }
    }

    private func processSelectedImage(_ image: UIImage) {
        processPickedImage(image)
    }

}

