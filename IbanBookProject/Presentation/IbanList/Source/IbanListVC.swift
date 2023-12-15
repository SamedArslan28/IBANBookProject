//
//  IBANList.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 6.11.2023.
//


import UIKit

final class IbanListVC: BaseVC, UINavigationControllerDelegate, IbanCellDelegate {
    
    // MARK: - OUTLETS
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var notificationLabel: BaseLabel!
    // MARK: - PROPERTIES
    
    private let viewModel = IbanListTableViewVM()
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - FUNCTIONS
    
    private func setupUI(){
        navigationController?.hidesBarsOnSwipe = false
        view.backgroundColor = .appBackgroundColor
        navigationController?.navigationBar.barTintColor = UIColor.appBackgroundColor
        navigationController?.isToolbarHidden = true
        setNavigationTitle(title: "IBAN'lar")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .appBackgroundColor
        tableView.register(type: IbanCell.self, identifier: "IbanCell")
        notificationLabel.alpha = 0
        notificationLabel.textColor = .themeColor
    }
    
    func showShareOptions(ibanName: String, ibanNumber: String, bankName: String) {
        let data = "\(ibanName)\n\(ibanNumber)\n\(bankName)"
        let shareVC = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        present(shareVC, animated: true)
    }
    
    func isCopiedToClipboard() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .showHideTransitionViews) {
            self.notificationLabel.alpha = 1
        }
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
            UIView.animate(withDuration: 0.5, delay: 0, options: .showHideTransitionViews) {
                self.notificationLabel.alpha = 0
            }
        }
    }
    
    func isFavChanged(id: String) {
        let foundItem = viewModel.items.first { item in item.itemId == id }
        foundItem?.isFavorite.toggle()
        UIView.transition(with: tableView, duration: 0.1, options: .transitionCrossDissolve) {
            self.tableView.reloadData()
        }
        viewModel.saveIban(ibanList: viewModel.items)
    }
}

// MARK: - TABLEVIEW EXTENSIONS

extension IbanListVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.titleHeader(in: section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        30.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 32))
        let label = BaseLabel(frame: CGRect(x: 32, y: 0, width: headerView.frame.width - 12, height: headerView.frame.height))
        label.text = viewModel.titleHeader(in: section)
        headerView.backgroundColor = .appBackgroundColor
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeue(withType: IbanCell.self, for: indexPath) as? IbanCell else{ return .init() }
        cell.delegate = self
        if indexPath.section == 0 {
            cell.favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }else{
            cell.favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
        cell.viewModel = IbanCellVM(ibanModel: viewModel.getIbanItem(at: indexPath))
        return cell
    }
}
