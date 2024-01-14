//
//  Coordinator.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 21.12.2023.
//deneme

import Foundation
import UIKit

public typealias CompletionBlock = () -> Void

enum ControllerKey: String {
    case main
    case ibanList
    case saveIban 
    
    var controllerType: AnyClass {
        switch self {
        case .main:
            return MainVC.self
        case .ibanList:
            return IbanListVC.self
        case .saveIban:
            return SaveIbanVC.self
        }
    }
}

private var dataAssociationKey: UInt8 = 0

extension UIViewController {
    var data: Any? {
        get { objc_getAssociatedObject(self, &dataAssociationKey) as Any? }
        set { objc_setAssociatedObject(self, &dataAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN) }
    }
}

protocol Navigable { }

extension Navigable where Self: UIViewController {
//    static func create() -> Self {
//        let nibName = String(describing: self)
//        let viewController = Self.init(nibName: nibName, bundle: .main)
//        return viewController
//    }
     
    func pushVC(key: ControllerKey, data: Any? = nil, animated: Bool = true) {
        guard let viewController = ControllerFactory.createVC(with: key) else { return }
        viewController.data = data
        navigationController?.pushViewController(viewController, animated: animated)
    }
    
    func presentVC(key: ControllerKey, data: Any? = nil, animated: Bool = true) {
        guard let viewController = ControllerFactory.createVC(with: key) else { return }
        viewController.data = data
        navigationController?.present(viewController, animated: animated)
    }
    
    func popVC(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }
    
    func dismissVC(animated: Bool = true, completion: CompletionBlock? = nil) {
        navigationController?.dismiss(animated: animated, completion: completion)
    }
}

final class ControllerFactory {
    static func createVC(with key: ControllerKey) -> UIViewController? {
        guard let controllerType = key.controllerType as? UIViewController.Type else { return nil }
        return controllerType.init()
    }
}
