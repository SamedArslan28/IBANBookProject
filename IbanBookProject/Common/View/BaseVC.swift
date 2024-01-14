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
        navigationController?.navigationBar.tintColor = .themeColor
    } 
    func setNavigationTitleColor (){
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.themeColor] 
    }
}
