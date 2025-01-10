//
//  BaseVC.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 6.11.2023.
//

import Foundation
import UIKit

/// `BaseVC` is a base view controller class providing utility functions
/// for setting navigation bar properties and applying background styling.
class BaseVC: UIViewController {

    // MARK: - FUNCTIONS

    /// Sets the navigation title for the view controller.
    /// - Parameter title: The title text to display in the navigation bar.
    func setNavigationTitle(title: String) {
        navigationItem.title = title
    }

    /// Sets the navigation bar tint color to a predefined theme color.
    func setNavigationColor() {
        guard let navigationController else { return }
        navigationController.navigationBar.tintColor = .themeColor
    }

    /// Sets the color of the navigation bar title text.
    /// - Parameter color: The color to use for the title text. Defaults to `.themeColor`.
    func setNavigationTitleColor(color: UIColor = .themeColor) {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: color]
    }

    /// Sets a gradient background for the view by calling `setGradientBackground`.
    func setBackground() {
        setGradientBackground()
    }

    /// Configures a gradient background for the view with specified top and bottom colors.
    /// This gradient covers the entire screen and is inserted as the first layer in the view.
    private func setGradientBackground() {
        let gradientLayer = CAGradientLayer()
        let screenBounds = UIScreen.main.bounds
        gradientLayer.frame = screenBounds
        gradientLayer.colors = [UIColor.gradientTopColor.cgColor, UIColor.gradientBottomColor.cgColor]
        gradientLayer.locations = [0.0, 0.5]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}
