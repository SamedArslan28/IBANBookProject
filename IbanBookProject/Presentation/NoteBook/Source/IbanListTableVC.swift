//
//  IBANList.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 6.11.2023.
//

import Foundation
import UIKit

final class IbanListTableVC: BaseVC, UITableViewDelegate, UITableViewDataSource {
    private let sections = ["Favoriler", "Kayıtlı IBAN`larim"]
    private let items = [["Item 1", "Item 2", "Item 3"], ["Item 4", "Item 5", "Item 5", "Item 5","Item 5","Item 5","Item 5"]]

    private let tableView = UITableView()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.insetsContentViewsToSafeArea = false
        tableView.frame = view.bounds



    }


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInsetAdjustmentBehavior = .always
        tableView.tableFooterView = UIView(frame: .zero)

        tableView.register(UINib(nibName: "IbanCell", bundle: nil), forCellReuseIdentifier: "IbanCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        setNavigationTitle(title: "IBAN'lar")
        view.addSubview(tableView)

    }


}


extension IbanListTableVC {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        CGFloat(50)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IbanCell", for: indexPath) as! IbanCell
        let item = items[indexPath.section][indexPath.row]

        // Configure the cell with the item
        cell.nameLabel.text = item
        cell.ibanLabel.text = "TR00 0000 0000 0000 0000 0000 00"

        return cell
    }
}
