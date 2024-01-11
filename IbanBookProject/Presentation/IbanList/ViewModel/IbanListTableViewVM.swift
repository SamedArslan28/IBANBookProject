//
//  IbanListTableViewVM.swift
//  IbanBookProject
//
//  Created by Göksu Subaşı on 30.11.2023.
//

import Foundation

enum SectionTypes: String {
    case favorites
    case nonFavorites
    case empty
    
    var header: String {
        switch self {
        case .favorites:
            return Constant.favoriteTitle
        case .nonFavorites:
            return Constant.nonFavoriteTitle
        default:
            return ""
        }
    }
    
    private enum Constant {
        static let favoriteTitle = "Favoriler".localized()
        static let nonFavoriteTitle = "Kayıtlı IBAN`larim".localized()
    }
}

final class IbanListTableViewVM {
    
    // MARK: - PRIVATE PROPERTIES
    
    private var items = [IbanModel]()
    private(set) var rowTypes: [SectionTypes] = []
    
    // MARK: - COMPUTED PROPERTIES
    
    private var nonFavoriteItemList: [IbanModel] { items.filter { !$0.isFavorite } }
    private var favoriteItemList: [IbanModel] { items.filter { $0.isFavorite } }
    var numberOfSection: Int { 
        items.removeAll()
        rowTypes.removeAll()
        items = getData()?.reversed() ?? []
        if favoriteItemList.isEmpty && nonFavoriteItemList.isEmpty {
            rowTypes.append(.empty)
            return rowTypes.count
        }
        if !favoriteItemList.isEmpty {
            rowTypes.append(.favorites)
        }
        if !nonFavoriteItemList.isEmpty {
            rowTypes.append(.nonFavorites)
        }
        return rowTypes.count
    }
    
    // MARK: - FUNCTIONS
    
    func numberOfRows(in section: Int) -> Int {
        guard let rowType = rowTypes.get(at: section) else { return 0 }
        switch rowType {
        case .favorites:
            return favoriteItemList.count
        case .nonFavorites:
            return nonFavoriteItemList.count
        case .empty:
            return 1
        }
    }
    
    func titleHeader(in section: Int) -> String {
        guard let rowType = rowTypes.get(at: section) else { return "" }
        return rowType.header
    }
    
    func getIbanCellVM(at indexPath: IndexPath) -> IbanCellVM? {
        guard let rowType = rowTypes.get(at: indexPath.section),
              let ibanItem = getIbanItem(rowType: rowType, at: indexPath) else { return nil }
        return IbanCellVM(ibanModel: ibanItem , rowType: rowType)
    }
    
    func getItemsCount() -> Bool {
        return items.isEmpty ? true : false
    }
    
    func changeFavoriteStatus(at id: String) {
        guard let foundItem = getItem(with: id) else { return }
        foundItem.isFavorite.toggle() // reference type
        updateIbanCache()
    }
    
    func deleteItemAtIndexPath(_ indexPath: IndexPath) {
        guard let rowType = rowTypes.get(at: indexPath.section) else { return }
        switch rowType {
        case .favorites:
            let item = favoriteItemList.get(at: indexPath.row)
            items.removeAll(where:{ $0.itemId == item?.itemId })
        case .nonFavorites:
            let item = nonFavoriteItemList.get(at: indexPath.row)
            items.removeAll(where:{ $0.itemId == item?.itemId })
        case .empty:
            break
        }
        updateIbanCache()
    }
    
    func savedIbans() -> [IbanModel] {
        return items
    }

    
    // MARK: - PRIVATE FUNCTIONS
    
    private func getItem(with id: String) -> IbanModel? {
        return items.first { $0.itemId == id }
    }
    
    private func getIbanItem(rowType: SectionTypes, at indexPath: IndexPath) -> IbanModel? {
        switch rowType {
        case .favorites:
            return favoriteItemList.get(at: indexPath.row)
        case .nonFavorites:
            return nonFavoriteItemList.get(at: indexPath.row)
        case .empty:
            return nil
        }
    }
    
    private func getData() -> [IbanModel]?{
        let decoder = JSONDecoder()
        guard let ibans = CacheManager.shared.getObject(key: Constant.ibanListCacheKey) else { return nil }
        return try? decoder.decode([IbanModel].self, from: ibans)
    }

    private func updateIbanCache() {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(items) else { return }
        CacheManager.shared.setObject(data, key: Constant.ibanListCacheKey)
    }
}

private extension IbanListTableViewVM {
    private enum Constant {
        static let ibanListCacheKey = "ibans"
    }
}
