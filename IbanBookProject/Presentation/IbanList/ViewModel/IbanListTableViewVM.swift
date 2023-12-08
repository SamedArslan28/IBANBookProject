//
//  IbanListTableViewVM.swift
//  IbanBookProject
//
//  Created by Göksu Subaşı on 30.11.2023.
//

import Foundation

private enum TableSectionTypes: String {
    case favorites = "Favoriler"
    case savedIbans = "Kayıtlı IBAN`larim"
}

final class IbanListTableViewVM {
    
    // MARK: - LIFECYCLE
    
    init() {
        items = getData()?.reversed() ?? []
    }
    
    // MARK: - PRIVATE PROPERTIES
    
    private let titles: [TableSectionTypes] = [.favorites, .savedIbans]
    private var items = [IbanModel]()
    
    // MARK: - COMPUTED PROPERTIES

    private var nonFavoriteItemList: [IbanModel] { items.filter { !$0.isFavorite } }
    private var favoriteItemList: [IbanModel] { items.filter { $0.isFavorite } }
    var numberOfSection: Int { titles.count }

    // MARK: - FUNCTIONS
    
    func numberOfRows(in section: Int) -> Int {
        switch titles[section] {
        case .favorites:
            favoriteItemList.count
        case .savedIbans:
            nonFavoriteItemList.count
        }
    }
    
    func titleHeader(in section: Int) -> String {
        return titles[section].rawValue
    }
    
    func getIbanItem(at indexPath: IndexPath) -> IbanModel {
        switch titles[indexPath.section] {
        case .favorites:
            favoriteItemList[indexPath.row]
        case .savedIbans:
            nonFavoriteItemList[indexPath.row]
        }
    }
    // MARK: - PRIVATE FUNCTIONS
    
    private func getData() -> [IbanModel]?{
        let decoder = JSONDecoder()
        guard let ibans = CacheManager.shared.getObject(key: "ibans") else { return nil }
        return try? decoder.decode([IbanModel].self, from: ibans)
    }
    
}
