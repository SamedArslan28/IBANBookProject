//
//  BaseLabel.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 27.10.2023.
//

import Foundation
import UIKit

final class BaseLabel: UILabel {

    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit(){

        font = .appFont
    }




}
