//
//  IBANList.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 6.11.2023.
//


import UIKit

final class IbanListVC: BaseVC, Navigable {
    
    // MARK: - OUTLETS
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - PROPERTIES
    
    private let viewModel = IbanListTableViewVM()
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupCopyAllButton()
    }
    
    // MARK: - FUNCTIONS
    
    private func setupUI() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureRecognized(_:)))
        view.setGradientBackground()
        setNavigationTitle(title: "ibanListKey".localized())
        navigationController?.isToolbarHidden = true
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        tableView.delegate = self
        tableView.addGestureRecognizer(longPressGesture)
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .none
        tableView.register(type: IbanCell.self)
        tableView.register(type: EmptyIBANCellTableViewCell.self)
        setupCustomBackButton()
    }
    
    private func setupCopyAllButton() {
        let copyAllButton = UIBarButtonItem(image: UIImage(systemName: "doc.on.doc")?.withTintColor(.themeColor),
                                               style: .plain,
                                               target: self,
                                               action: #selector(copyAllIbans))
        copyAllButton.customView?.isUserInteractionEnabled = true
        navigationItem.rightBarButtonItem = copyAllButton
    }
    
    private func setupCustomBackButton() {
        let customBackButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"),
                                               style: .plain,
                                               target: self,
                                               action: #selector(popToMainVC))
        customBackButton.customView?.isUserInteractionEnabled = true
        navigationItem.leftBarButtonItem = customBackButton
    }
}

// MARK: - TABLEVIEW EXTENSIONS

extension IbanListVC: UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.titleHeader(in: section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        30.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = viewModel.rowTypes.get(at: indexPath.section) else { return .init() }
        return section == .empty ? 300 : UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 32))
        let label = BaseLabel(frame: CGRect(x: 32, y: 0, width: headerView.frame.width - 12, height: headerView.frame.height))
        label.text = viewModel.titleHeader(in: section)
        headerView.backgroundColor = .none
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = viewModel.rowTypes.get(at: indexPath.section) else { return .init() }
        switch section {
        case .favorites, .nonFavorites:
            guard let cell = tableView.dequeue(withType: IbanCell.self, for: indexPath) as? IbanCell else { return .init() }
            cell.delegate = self
            cell.viewModel = viewModel.getIbanCellVM(at: indexPath)
            return cell
        case .empty:
            guard let cell = tableView.dequeue(withType: EmptyIBANCellTableViewCell.self, for: indexPath) as? EmptyIBANCellTableViewCell else { return .init() }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, completion in
            self?.viewModel.deleteItemAtIndexPath(indexPath)
            UIView.transition(with: tableView, duration: 0.1, options: .transitionCrossDissolve) {
                self?.tableView.reloadData()
            }
            completion(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction])
        swipeConfig.performsFirstActionWithFullSwipe = false
        return swipeConfig
    }
    
    @objc func popToMainVC() {
        if (navigationController?.viewControllers.count)! > 2 {
            popToMain()
        }else {
            popVC(animated: true)
        }
    }
    
    @objc func copyAllIbans() {
        let decoder = JSONDecoder()
        guard let ibans = CacheManager.shared.getObject(key: "ibans") else { return }
        let savedIbans = try? decoder.decode([IbanModel].self, from: ibans)
        var allIbansString = ""
        savedIbans?.forEach({ item in
             allIbansString = "\(allIbansString) \(item.ibanName)\n\(item.ibanNumber)\n\(item.bankName)\n"
        })
        UIPasteboard.general.string = allIbansString

    }
    
    @objc func longPressGestureRecognized(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let location = sender.location(in: self.tableView)
            if let indexPath = self.tableView.indexPathForRow(at: location) {
                if let cell = self.tableView.cellForRow(at: indexPath) as? IbanCell {
                    let propertyToCopy = cell.viewModel?.iban
                    UIPasteboard.general.string = propertyToCopy
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                    showToast(message: "copyIbanKey".localized(), font: .systemFont(ofSize: 12))
                }
            }
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
    
    func isFavChanged(id: String) {
        viewModel.changeFavoriteStatus(at: id)
        UIView.transition(with: tableView, duration: 0.1, options: .transitionCrossDissolve) {
            self.tableView.reloadData()
        }
    }
}
