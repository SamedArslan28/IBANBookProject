//
//  ControllerType.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 16.09.2024.
//

import Foundation

enum ControllerKey: String {
    case main
    case ibanList
    case saveIban
    case settings
    case camera

    var controllerType: AnyClass {
        switch self {
        case .main:
            return MainVC.self
        case .ibanList:
            return IbanListVC.self
        case .saveIban:
            return SaveIbanVC.self
        case .settings:
            return SettingsVC.self
        case .camera:
            return CameraSessionVC.self
        }
    }
}
