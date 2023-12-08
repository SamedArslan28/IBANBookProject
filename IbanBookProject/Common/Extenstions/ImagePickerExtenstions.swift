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
        
        // Check if an image is selected
        if let pickedImage = info[.originalImage] as? UIImage {
            // Use the pickedImage as needed, such as displaying it in an imageView
            // For example, you can set it to an imageView named ibanImageView
            let visionImage = VisionImage(image: pickedImage)
            let latinOptions = TextRecognizerOptions()
            let latinTextRecognizer = TextRecognizer.textRecognizer(options:latinOptions)
            var ibanFound = false
            latinTextRecognizer.process(visionImage) { result, error in
                guard error == nil, let result = result else {
                    // Handle the error
                    print("Error recognizing text: \(error?.localizedDescription ?? "")")
                    return
                }
                
                // Process the recognized text
                
                guard !result.blocks.isEmpty else {
                    // Display an error message
                    let alertController = UIAlertController(title: "Herhangi bir IBAN bulunmadi", message: "Lutfen IBAN iceren bir resim seciniz", preferredStyle: .alert)
                    
                    let dismissAction = UIAlertAction(title: "Tamam", style: .default) { _ in
                        // Handle any action you want to perform when the dismiss button is tapped
                        print("Dismiss button tapped")
                    }
                    
                    alertController.addAction(dismissAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    // You can show an alert or update the UI to inform the user about the error
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
                    // Display an error message
                    let alertController = UIAlertController(title: "IBAN bulunamadi", message: "Lutfen baska bir fotograf seciniz", preferredStyle: .alert)
                    
                    let dismissAction = UIAlertAction(title: "Tamam", style: .default) { _ in
                        // Handle any action you want to perform when the dismiss button is tapped
                        
                    }
                        // You can show an alert or update the UI to inform the user about the error
                        alertController.addAction(dismissAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                    
                    
                }
                
                // Dismiss the image picker
                
            }
            
            picker.dismiss(animated: true, completion: nil)
        }
        
    }
}
