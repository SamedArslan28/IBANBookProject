//
//  IBANList.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 6.11.2023.
//


import UIKit

final class IbanListVC: BaseVC, UINavigationControllerDelegate, Navigable {
    
    // MARK: - OUTLETS
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - PROPERTIES
    
    private let viewModel = IbanListTableViewVM()
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateEmptyMessage()
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
        guard let cell = tableView.dequeue(withType: IbanCell.self, for: indexPath) as? IbanCell else { return .init() }
        cell.delegate = self
        cell.viewModel = viewModel.getIbanCellVM(at: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [ weak self ](_, _, completion) in
            self?.viewModel.deleteItemAtIndexPath(indexPath)
//            tableView.beginUpdates()
//            tableView.deleteRows(at: [indexPath], with: .fade)
//            tableView.endUpdates()
            completion(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction])
        swipeConfig.performsFirstActionWithFullSwipe = false
        return swipeConfig
    }
    
    private func updateEmptyMessage() {
        if viewModel.getItemsCount() {
            let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            messageLabel.text = "Kayıtlı IBAN bulunmamaktadır."
            messageLabel.textAlignment = .center
            messageLabel.textColor = .gray
            messageLabel.numberOfLines = 0
            tableView.backgroundView = messageLabel
            tableView.separatorStyle = .none
        } else {
            tableView.backgroundView = nil
        }
    }
}

// MARK: - IBAN CELL DELEGATE

extension IbanListVC: IbanCellDelegate {
    func showShareOptions(ibanName: String, ibanNumber: String, bankName: String) {
        let data = "\(ibanName)\n\(ibanNumber)\n\(bankName)"
        let shareVC = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        present(shareVC, animated: true)
    }
    
    func isCopiedToClipboard() {
        showToast(message: "Coppied to Clipboard", font: .appFont()!)
    }
    
    func isFavChanged(id: String) {
        viewModel.changeFavoriteStatus(at: id)
        UIView.transition(with: tableView, duration: 0.1, options: .transitionCrossDissolve) {
            self.tableView.reloadData()
        }
    }
    
    func showToast(message : String, font: UIFont) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 3.0, delay: 0.0, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
