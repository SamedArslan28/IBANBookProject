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
    
    // MARK: PRIVATE PROPERTIES
    
    private let titles: [TableSectionTypes] = [.favorites, .savedIbans]
    private let items = [IbanModel(ibanNumber: "aaakskan", bankName: "şklefmsk", ibanName: "sldkmfskndf"),
                         IbanModel(ibanNumber: "bbbakskan", bankName: "alksnfaknfşklefmsk", ibanName: "aknflkansldkmfskndf"),
                         IbanModel(ibanNumber: "cccakskan", bankName: "şklefmsk", ibanName: "sldkmfskndf", isFavorite: true),
                         IbanModel(ibanNumber: "dddakskan", bankName: "şklefmsk", ibanName: "sldkmfskndf", isFavorite: true)]
    
    // MARK: COMPUTED PROPERTIES

    private var nonFavoriteItemList: [IbanModel] { items.filter { !$0.isFavorite } }
    private var favoriteItemList: [IbanModel] { items.filter { $0.isFavorite } }
    var numberOfSection: Int { titles.count }

    // MARK: FUNCTIONS
    
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
}
