//
//  EmptyIBANCellTableViewCell.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 9.01.2024.
//

import UIKit

final class EmptyIBANCellTableViewCell: UITableViewCell {

    // MARK: - PROPERTIES

    @IBOutlet private weak var messageLabel: BaseLabel!

    // MARK: - LIFECYCLE

    override func awakeFromNib() {
        super.awakeFromNib()
        messageLabel.text = "emptyCellKey".localized()
    }
}
