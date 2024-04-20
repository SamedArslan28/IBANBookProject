//
//  EmptyIBANCellTableViewCell.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 9.01.2024.
//

import UIKit

final class EmptyIBANCellTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var messageLabel: BaseLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageLabel.text = "emptyCellKey".localized()
    }
}
