//
//  ColorExtentsion.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 3.11.2023.
//

import Foundation
import UIKit


extension UIColor {
    /// The theme color of the app represented by the hex code `#f15a2f`.
    ///
    /// This static property returns a UIColor object with the RGB values corresponding
    /// to the hex color `#f15a2f`.
    ///
    /// - Returns: A UIColor instance representing the theme color.
    static var themeColor: UIColor {
        return UIColor(red: 0.9450980392156862, green: 0.35294117647058826, blue: 0.1843137254901961, alpha: 1)
    }

    /// `UITableView Cell` background color for showing saved items
    ///
    /// This static property returns a UIColor object with the RGB vlaues corresponding
    /// to the hex color `#ECECEC`.
    ///
    /// - Returns: A `UIColor` instance representing the `UITableView Cell` background color.

    static var cellBackgroundColor: UIColor{
        return UIColor(red: 0.9254901960784314, green: 0.9254901960784314, blue: 0.9254901960784314, alpha: 1)
    }

    /// Top gradient color for background.
    ///
    /// This static property returns a `UIColor` object with the RGB values corresponding
    /// to the hex color `#EEE0E5` (238, 224, 229).
    ///
    /// - Returns: A `UIColor` instance representing the top color of a gradient background.
    static var gradientTopColor: UIColor {
        return UIColor(red: 238/255, green: 224/255, blue: 229/255, alpha: 1)
    }

    /// Bottom gradient color for background.
    ///
    /// This static property returns a `UIColor` object with the RGB values corresponding
    /// to the hex color `#FAF0E6` (250, 240, 230).
    ///
    /// - Returns: A `UIColor` instance representing the bottom color of a gradient background.
    static var gradientBottomColor: UIColor {
        return UIColor(red: 250/255, green: 240/255, blue: 230/255, alpha: 1)
    }

}
