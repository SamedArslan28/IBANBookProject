//
//  IbanReaderManager.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 9.12.2023.
//

import Foundation
import UIKit
import MLKitVision
import MLKitTextRecognition

class IbanReaderManager {
    private init(){ }
    
    static let shared = IbanReaderManager()
    
    func processImage(image: UIImage, viewController: UIViewController){
        
        let pickedImage = image
        let visionImage = VisionImage(image: pickedImage)
        let latinOptions = TextRecognizerOptions()
        let latinTextRecognizer = TextRecognizer.textRecognizer(options:latinOptions)
        var ibanFound = false
        latinTextRecognizer.process(visionImage) { result, error in
            guard error == nil, let result = result else {
                print("Error recognizing text: \(error?.localizedDescription ?? "")")
                return
            }
            if let !result.blocks.isEmpty  {
                CustomAlerts.shared.showActionAlertCancel(errorTitle: "demo", errorMessage: "demo", viewController: viewController)
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
                CustomAlerts.shared.showActionAlertCancel(errorTitle: "demo2", errorMessage: "demo2", viewController: viewController)
            }
        }
        
        
    }
}
