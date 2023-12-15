//
//  IBANcell.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 7.11.2023.
//

import UIKit



final class IbanCell: UITableViewCell {
  
    // MARK: - OUTLET
    
    @IBOutlet weak var favoriteButton: BaseButton!
    @IBOutlet private weak var bankLabel: BaseLabel!
    @IBOutlet private weak var shareButton: BaseButton!
    @IBOutlet private weak var copyButton: BaseButton!
    @IBOutlet private weak var nameLabel: BaseLabel!
    @IBOutlet private weak var ibanLabel: BaseLabel!
    @IBOutlet private weak var itemContainerView: UIView!
    
    // MARK: - PROPERTIES
    
    var viewModel: IbanCellVM? {
        didSet {
            prepareUI()
        }
    }
    var delegate: IbanCellDelegate?
        
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
    }
    @IBAction private func shareButtonTapped(_ sender: Any) {
        guard let viewModel = viewModel else { return }
        delegate?.showShareOptions(ibanName: viewModel.ibanName, ibanNumber: viewModel.iban, bankName: viewModel.bankName)
    }
    @IBAction func copyButtonTapped(_ sender: Any) {
        guard let viewModel = viewModel else{ return }
        let data = "\(viewModel.iban)"
        UIPasteboard.general.string = data
        delegate?.isCopiedToClipboard()
    }
    @IBAction func favouriteButtonTapped(_ sender: Any) {
        delegate?.isFavChanged(id: viewModel!.id)
    }
}
