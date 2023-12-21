//
//  Coordinator.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 21.12.2023.
//

import Foundation
import UIKit

enum Event {
    case IbanList
    case SaveIban
}

protocol Coordinator {
    var navigationController: UINavigationController? { get set }
    func start()
    func eventOccured(with type: Event)
}

protocol Coordinating {
    var coordinator: Coordinator? { get set }
}
