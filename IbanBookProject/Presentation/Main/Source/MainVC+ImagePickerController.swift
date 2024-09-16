//
//  MainVC+ImagePickerController.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 13.09.2024.
//

import UIKit

extension MainVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            picker.dismiss(animated: true, completion: nil)
            return
        }
        picker.dismiss(animated: true, completion: nil)
        processPickedImage(image)
    }
}
