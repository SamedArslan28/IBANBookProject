//
//  BaseButton.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 27.10.2023.
//

import Foundation
import UIKit

final class BaseButton: UIButton {

    override func awakeFromNib() {

        super.awakeFromNib()

        backgroundColor = .themeColor
        layer.cornerRadius = 4
        tintColor = .white
        


    }


    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel?.font = UIFont(name: "OpenSans-Regular", size: 25)


        

    }

}
