//
//  BaseLabel.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 27.10.2023.
//

import Foundation
import UIKit

final class BaseLabel: UILabel {

    // MARK: - LIFECYCLE

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit(){
        font = .appFont(16)
    }
}
