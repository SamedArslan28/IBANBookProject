//
//  BaseButton.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 27.10.2023.
//

import Foundation
import UIKit

final class BaseButton: UIButton {
    
    // MARK: - LIFECYCLE

    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    // MARK: - PRIVATE FUNCTIONS
    
    private func commonInit() {
        // Customize other button properties here if needed
        let customFont =  UIFont(name: "OpenSans-Regular", size: 15)
        backgroundColor = .themeColor
        tintColor = .white
        layer.cornerRadius = 16.0
        titleLabel?.textAlignment = .center
        titleLabel?.font = customFont
    }
}
