//
//  IBANList.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 6.11.2023.
//

import Foundation
import UIKit

final class IbanListTableVC: BaseVC, UINavigationControllerDelegate {

    // MARK: - OUTLETS
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - PROPERTIES
    
    private let viewModel = IbanListTableViewVM()

    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(title: "IBAN'lar")
        navigationController?.hidesBarsOnSwipe = false
        view.backgroundColor = .appBackgroundColor
        navigationController?.navigationBar.barTintColor = UIColor.appBackgroundColor
        navigationController?.isToolbarHidden = true

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .appBackgroundColor
        tableView.register(type: IbanCell.self, identifier: "IbanCell")
    }
}

// MARK: - TABLEVIEW EXTENSIONS
extension IbanListTableVC: UITableViewDelegate, UITableViewDataSource {
    
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
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
        let label = BaseLabel(frame: CGRect(x: 32, y: 0, width: headerView.frame.width - 10, height: headerView.frame.height))
        label.text = viewModel.titleHeader(in: section)
        
        headerView.backgroundColor = .appBackgroundColor
        headerView.addSubview(label)
        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeue(withType: IbanCell.self, for: indexPath) as? IbanCell else{ return .init() }
        cell.viewModel = IbanCellVM(ibanModel: viewModel.getIbanItem(at: indexPath))
        return cell
    }
}
