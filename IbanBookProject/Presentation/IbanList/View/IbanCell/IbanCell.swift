//
//  IBANcell.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 7.11.2023.
//

import UIKit

final class IbanCell: UITableViewCell {

    // MARK: - OUTLET
    
    @IBOutlet private weak var favoriteButton: UIButton!
    @IBOutlet private weak var bankLabel: UILabel!
    @IBOutlet private weak var shareButton: UIButton!
    @IBOutlet private weak var copyButton: UIButton!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var ibanLabel: UILabel!
    @IBOutlet private weak var itemContainerView: UIView!
    
    // MARK: - PROPERTIES
    
    var viewModel: IbanCellVM? {
        didSet {
            prepareUI()
        }
    }
    
    // MARK: - LIFE CYCLE
    
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
    
    // MARK: - PRIVATE FUNCTIONS
    
    private func prepareUI() {
        guard let viewModel else { return }
        nameLabel.text = viewModel.ibanName
        ibanLabel.text = viewModel.iban
        bankLabel.text = viewModel.bankName
        shareButton.titleLabel?.text = ""
        favoriteButton.titleLabel?.text = ""
        copyButton.titleLabel?.text = ""
    }
}
