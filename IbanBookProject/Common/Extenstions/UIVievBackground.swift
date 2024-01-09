//
//  UIVievBackground.swift
//  IbanBookProject
//
//  Created by Göksu Subaşı on 9.01.2024.
//
import Foundation
import UIKit

extension UIView{
    func setGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.colorOne.cgColor,UIColor.colorTwo.cgColor]
        gradientLayer.locations = [0.0, 0.5]
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
