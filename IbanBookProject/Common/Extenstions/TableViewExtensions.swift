//
//  TableViewExtensions.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 7.11.2023.
///
///

import Foundation
import UIKit
extension UITableView {
    
    /**
     Register nibs faster by passing the type - if for some reason the `identifier` is different then it can be passed
     - Parameter type: UITableViewCell.Type
     - Parameter identifier: String?
     */
    func register(type: UITableViewCell.Type) {
        register(UINib(nibName: String(describing: type), bundle: nil), forCellReuseIdentifier: type.identifier)
    }
    
    /**
     DequeueCell by passing the type of UITableViewCell
     - Parameter type: UITableViewCell.Type
     */
    func dequeue<T: UITableViewCell>(withType type: UITableViewCell.Type) -> T? {
        return dequeueReusableCell(withIdentifier: type.identifier) as? T
    }
    
    /**
     DequeueCell by passing the type of UITableViewCell and IndexPath
     - Parameter type: UITableViewCell.Type
     - Parameter indexPath: IndexPath
     */
    func dequeue<T: UITableViewCell>(withType type: UITableViewCell.Type, for indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withIdentifier: type.identifier, for: indexPath) as? T
    }
    

}

extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
