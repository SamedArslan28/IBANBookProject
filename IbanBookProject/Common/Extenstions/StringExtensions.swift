//
//  StringExtensions.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 27.10.2023.
//

import Foundation
import UIKit

extension String {
    func isIban() -> Bool {
        let pattern = "TR\\s?[0-9]{2}\\s?[0-9]{4}\\s?[0-9]{4}\\s?[0-9]{4}\\s?[0-9]{4}\\s?[0-9]{4}\\s?[0-9]{2}"
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return false
        }
        let range = NSRange(location: 0, length: self.utf16.count)
        let matches = regex.matches(in: self, options: [], range: range)
        return !matches.isEmpty
    }
    
    func extractIban() -> String? {
        let pattern = "TR\\s?[0-9]{2}\\s?[0-9]{4}\\s?[0-9]{4}\\s?[0-9]{4}\\s?[0-9]{4}\\s?[0-9]{4}\\s?[0-9]{2}"
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return nil
        }
        let range = NSRange(location: 0, length: self.utf16.count)
        let matches = regex.matches(in: self, options: [], range: range)
        if let match = matches.first {
            let matchRange = match.range
            if let swiftRange = Range(matchRange, in: self) {
                let extractedIban = String(self[swiftRange])
                return extractedIban
            }
        }
        return nil
    }
    
    func localized() -> String {
        let lang = CacheManager.shared.getString(key: "languageCode")
        guard let path = Bundle.main.path(forResource: lang, ofType: ".lproj") else { return ""}
        let bundle = Bundle(path: path)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    } 
    
}
