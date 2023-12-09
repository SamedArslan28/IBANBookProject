//
//  CollectionsExtensions.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 9.12.2023.
//

import Foundation

extension Collection {
    func get(at index: Index) -> Element? {
        return self.indices.contains(index) ? self[index] : nil
    }
}

