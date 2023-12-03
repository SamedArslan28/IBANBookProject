//
//  MainMV.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 2.12.2023.
//

import Foundation
import UIKit


final class MainMV{
    
    // MARK: - PROPERTIES
    
    var descriptionLabelText: String {
        return "Iban Defteri uygulaması sayesinde Iban`larınızı telefon kameranızla ya da galerinizdeki resimden okuyabilirsiniz. \n\n Aynı zamanda Iban'ları kolayca kaydedebilir ve yakınlarınızla paylaşabilirsiniz."
    }
    
    var saveIbanButtonTitle: String {
        return "IBAN Kaydet"
    }
    
    var ibanListButtonTitle: String {
        return "IBAN Defteri"
    }
    
    var readIbanButtonTitle: String {
        return "IBAN Oku"
    }
    
    
    // MARK: - FUNCTIONS
    
    enum SourceType {
        case camera
        case photoLibrary
    }
    
    func handlePhotoSourceSelection(sourceType: SourceType, viewController: MainVC) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = viewController
        
        switch sourceType {
        case .camera:
            imagePicker.sourceType = .camera
        case .photoLibrary:
            imagePicker.sourceType = .photoLibrary
        
        }
        
        viewController.present(imagePicker, animated: true)
    }
}
