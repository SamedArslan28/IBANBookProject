//
//  BaseVC.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 6.11.2023.
//

import Foundation
import UIKit

class BaseVC: UIViewController {

    func setNavigationTitle(title: String) {
        navigationItem.title = title
    }

    func setNavigationColor (){
        navigationItem.titleView?.tintColor = .appBackgroundColor
    }
}
