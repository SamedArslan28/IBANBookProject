//
//  BaseVC.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 6.11.2023.
//

import Foundation
import UIKit

class BaseVC: UIViewController {

    // MARK: - FUNCTIONS
    
    func setNavigationTitle(title: String) {
        navigationItem.title = title
    }

    func setNavigationColor (){
        guard let navigationController else { return }
        navigationController.navigationBar.tintColor = .themeColor
    } 
    
    func setNavigationTitleColor (color: UIColor = .themeColor){
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: color] 
    }

    func setBackground() {
        setGradientBackground()
    }

    private func setGradientBackground() {
        let gradientLayer = CAGradientLayer()
        let screenBounds = UIScreen.main.bounds
        gradientLayer.frame = screenBounds
        gradientLayer.colors = [UIColor.gradientTopColor.cgColor, UIColor.gradientBottomColor.cgColor]
        gradientLayer.locations = [0.0, 0.5]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}
