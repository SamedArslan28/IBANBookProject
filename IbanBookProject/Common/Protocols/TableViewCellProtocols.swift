//
//  TableViewCellProtocols.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 15.12.2023.
//

import Foundation

protocol IbanCellDelegate {
    func showShareOptions(ibanName:String, ibanNumber:String, bankName:String)
    func isCopiedToClipboard()
    func isFavChanged(id: String)
}
