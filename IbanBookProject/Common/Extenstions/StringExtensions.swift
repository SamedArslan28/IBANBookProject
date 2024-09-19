//
//  StringExtensions.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 27.10.2023.
//

import Foundation
import UIKit

extension String {

    /// Checks if the string matches the IBAN format for Turkey.
    ///
    /// This function applies a regular expression pattern to verify if the string
    /// follows the structure of a Turkish IBAN (starting with "TR" followed by 24 digits).
    ///
    /// - Returns: `true` if the string is in a valid Turkish IBAN format, otherwise `false`.
    func isIban() -> Bool {
        let pattern = "TR\\s?[0-9]{2}\\s?[0-9]{4}\\s?[0-9]{4}\\s?[0-9]{4}\\s?[0-9]{4}\\s?[0-9]{4}\\s?[0-9]{2}"
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return false
        }
        let range = NSRange(location: 0, length: self.utf16.count)
        let matches = regex.matches(in: self, options: [], range: range)
        return !matches.isEmpty
    }

    /// Extracts the first occurrence of a valid Turkish IBAN from the string.
    ///
    /// This function searches the string for a Turkish IBAN using a regular expression
    /// and returns the first match if found.
    ///
    /// - Returns: A `String` containing the extracted IBAN if found, otherwise `nil`.
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

    /// Localizes the string based on the user's selected language.
    ///
    /// This function retrieves the user's language preference from `CacheManager`
    /// and attempts to localize the string using the appropriate `.lproj` file.
    ///
    /// - Returns: The localized version of the string if available, otherwise an empty string.
    func localized() -> String {
        let lang = CacheManager.shared.getString(key: "languageCode")
        guard let path = Bundle.main.path(forResource: lang, ofType: ".lproj") else { return "" }
        let bundle = Bundle(path: path)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }

    func removeIban() -> String {
        let pattern = "TR\\s?[0-9]{2}\\s?[0-9]{4}\\s?[0-9]{4}\\s?[0-9]{4}\\s?[0-9]{4}\\s?[0-9]{4}\\s?[0-9]{2}"
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return self
        }
        let range = NSRange(location: 0, length: self.utf16.count)
        let result = regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "")
        return result.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
