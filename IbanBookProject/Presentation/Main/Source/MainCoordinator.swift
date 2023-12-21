//
//  MainCoordinator.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 21.12.2023.
//

import Foundation
import UIKit

final class MainCoordinator: Coordinator {
    var navigationController: UINavigationController?
    
    func start() {
        let vc = MainVC(nibName: "MainVC", bundle: Bundle.main)
        vc.coordinator = self
        navigationController?.setViewControllers([vc], animated: false)
    }
    
    func eventOccured(with type: Event) {
        switch type {
        case .IbanList:
            let vc = IbanListVC(nibName: "IbanListVC", bundle: Bundle.main)
            vc.coordinator = self
            navigationController?.pushViewController(vc, animated: true)
        case .SaveIban:
            let vc = SaveIbanVC(nibName: "SaveIbanVC", bundle: Bundle.main)
            vc.coordinator = self
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    
}
