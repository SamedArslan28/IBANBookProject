//
//  IBANcell.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 7.11.2023.
//

import UIKit

class IbanCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ibanLabel: UILabel!
    
    
    @IBOutlet weak var itemContainerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        nameLabel.font = .appFont(16)
        ibanLabel.font = .appFont(16)
        itemContainerView.layer.cornerRadius = 12
        itemContainerView.layer.borderColor = UIColor.black.cgColor
        itemContainerView.layer.borderWidth = 1
        itemContainerView.layer.backgroundColor = UIColor.appBackgroundColor.cgColor
        itemContainerView.clipsToBounds = true

    }
}
