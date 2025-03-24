//
//  SceneDelegate.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 15.08.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene),
              let viewController = ControllerFactory.createVC(with: .main) else { return }
        let window = UIWindow(windowScene: windowScene)
        let navController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navController
        window.makeKeyAndVisible()
        self.window = window
    }
}

