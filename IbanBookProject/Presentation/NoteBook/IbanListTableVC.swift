//
//  IBANList.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 6.11.2023.
//

import Foundation
import UIKit

final class IbanListTableVC: UITableViewController {
    private let sections = ["Favoriler", "Kayıtlı IBAN`larim"]
    private let items = [["Item 1", "Item 2", "Item 3"], ["Item 4", "Item 5"]]

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IbanCell", for: indexPath) as! IbanCell
        let item = items[indexPath.section][indexPath.row]

        // Configure the cell with the item
        cell.nameLabel.text = item
        cell.ibanLabel.text = "TR00 0000 0000 0000 0000 0000 00"

        return cell
    }


    override func viewDidLoad() {
        tableView.register(UINib(nibName: "IbanCell", bundle: nil), forCellReuseIdentifier: "IbanCell")
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .appBackgroundColor
    }


}
