//
//  IBANList.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 6.11.2023.
//

import Foundation
import UIKit

final class IbanListTableVC: BaseVC, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    private let sections = ["Favoriler", "Kayıtlı IBAN`larim"]
    private var items = [[IbanModel](), [IbanModel]()]

    let userDefaults = UserDefaults.standard
    var ibanList = [IbanModel]()

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

     

    }


    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(type: IbanCell.self, identifier: "IbanCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        setNavigationTitle(title: "IBAN'lar")
        tableView.backgroundColor = .appBackgroundColor
        
        navigationController?.hidesBarsOnSwipe = false
        view.backgroundColor = .appBackgroundColor
        navigationController?.navigationBar.barTintColor = UIColor.appBackgroundColor
        navigationController?.isToolbarHidden = true
        
        if let savedList = userDefaults.data(forKey: "ibanList") {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()
                
                // Decode Note
                let note = try decoder.decode([IbanModel].self, from: savedList)
                ibanList = note
                items[1] = note
                for note in note{
                    if note.isFav {
                        items[0].append(note)
                    }
                    
                    
                }
                
                
            } catch {
                print("Unable to Decode Note (\(error))")
            }
        }

    }


}


extension IbanListTableVC {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        CGFloat(30)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section]
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 30))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 32, y: 0, width: headerView.frame.width-10, height: headerView.frame.height)
        label.text = sections[section]
        label.font = .appFont()
        label.textColor = .black
        headerView.backgroundColor = .appBackgroundColor
        
        headerView.addSubview(label)
        
        return headerView
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeue(withType: IbanCell.self, for: indexPath) as? IbanCell else{ return UITableViewCell() }
        let item = items[indexPath.section][indexPath.row]
        
        // Configure the cell with the item
        cell.nameLabel.text = item.ibanName
        cell.ibanLabel.text = "TR00 0000 0000 0000 0000 0000 00"
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = items[1][indexPath.row]
        selectedItem.isFav = true
        
    }
    
}
