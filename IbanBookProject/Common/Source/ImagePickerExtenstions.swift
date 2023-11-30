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
            
            latinTextRecognizer.process(visionImage) { result, error in
                guard error == nil, let result = result else {
                    // Handle the error
                    print("Error recognizing text: \(error?.localizedDescription ?? "")")
                    return
                }
                
                // Process the recognized text
              
                for block in result.blocks {
                    for line in block.lines {
                        let lineText = line.text
                        if lineText.isIban() {
                            let foundIban = lineText.extractIban()
                            self.foundIbans.append(foundIban!)
                            
                            
                        }
                    
                    }
                }
                print(self.foundIbans)
            }
            
            // Dismiss the image picker
            
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
}
