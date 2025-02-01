//
//  Coordinator.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 21.12.2023.
//

import Foundation
import UIKit

/// A type alias for a completion block with no parameters and no return value.
public typealias CompletionBlock = () -> Void

/// A private variable to store associated data with `UIViewController` instances.
private var dataAssociationKey: UInt8 = 0

extension UIViewController {
    /// A property for associating arbitrary data with a `UIViewController` instance.
    /// The data can be of any type and is retained throughout the view controller's lifecycle.
    var data: Any? {
        get { objc_getAssociatedObject(self, &dataAssociationKey) as Any? }
        set { objc_setAssociatedObject(self, &dataAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN) }
    }
}

/// A protocol representing a navigable view controller, providing methods for navigation actions.
protocol Navigable { }

extension Navigable where Self: UIViewController {

    /// Pushes a new view controller onto the navigation stack.
    /// - Parameters:
    ///   - key: The identifier for the target view controller type, defined by `ControllerKey`.
    ///   - data: Optional data to associate with the target view controller.
    ///   - animated: Boolean value to determine if the transition should be animated.
    func pushVC(key: ControllerKey, data: Any? = nil, animated: Bool = true) {
        guard let viewController = ControllerFactory.createVC(with: key) else { return }
        viewController.data = data
        navigationController?.pushViewController(viewController, animated: animated)
    }

    /// Presents a new view controller modally.
    /// - Parameters:
    ///   - key: The identifier for the target view controller type, defined by `ControllerKey`.
    ///   - data: Optional data to associate with the target view controller.
    ///   - animated: Boolean value to determine if the transition should be animated.
    func presentVC(key: ControllerKey, data: Any? = nil, animated: Bool = true) {
        guard let viewController = ControllerFactory.createVC(with: key) else { return }
        viewController.data = data
        navigationController?.present(viewController, animated: animated)
    }

    /// Pops the top view controller from the navigation stack.
    /// - Parameter animated: Boolean value to determine if the transition should be animated.
    func popVC(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }

    /// Dismisses the current view controller if it was presented modally.
    /// - Parameters:
    ///   - animated: Boolean value to determine if the transition should be animated.
    ///   - completion: An optional completion block to execute after the dismissal.
    func dismissVC(animated: Bool = true, completion: CompletionBlock? = nil) {
        navigationController?.dismiss(animated: animated, completion: completion)
    }

    /// Pops all view controllers on the navigation stack until reaching the root view controller.
    func popToMain() {
        guard let navigationController else { return }
        navigationController.popToRootViewController(animated: true)
    }

    /// Removes current view controller from navigation stack.
    ///  - Note: Use it with views disappear lifecycle functions.
    func removeCurrentFromStack() {
        if let navigationController = self.navigationController {
            var viewControllers = navigationController.viewControllers
            viewControllers.removeAll { $0 is Self }
            navigationController.viewControllers = viewControllers
        }
    }

    /// Resarts the application from Main view controller with animation.
    func restartApplication() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }),
              let viewController = ControllerFactory.createVC(with: .main) else { return }

        let navCtrl = UINavigationController(rootViewController: viewController)
        UIView.transition(with: window, duration: 0.3, options: .curveEaseInOut, animations: {
            window.rootViewController = navCtrl
        })
    }
}

/// A factory responsible for creating view controllers based on a specified key.
final class ControllerFactory {
    /// Creates and returns a view controller based on the specified `ControllerKey`.
    /// - Parameter key: The key used to identify the type of view controller to create.
    /// - Returns: A new instance of the specified view controller, or `nil` if creation fails.
    static func createVC(with key: ControllerKey) -> UIViewController? {
        guard let controllerType = key.controllerType as? UIViewController.Type else { return nil }
        return controllerType.init()
    }
}
