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
        // Define the pattern
        let pattern = "TR\\s?[0-9]{2}\\s?[0-9]{4}\\s?[0-9]{4}\\s?[0-9]{4}\\s?[0-9]{4}\\s?[0-9]{4}\\s?[0-9]{2}"
        // Create a regular expression object
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return false
        }
        // Find matches in the string
        let range = NSRange(location: 0, length: self.utf16.count)
        let matches = regex.matches(in: self, options: [], range: range)
        // Check if there is at least one match
        return !matches.isEmpty
    }
    
    func extractIban() -> String? {
        // Define the pattern
        let pattern = "TR\\s?[0-9]{2}\\s?[0-9]{4}\\s?[0-9]{4}\\s?[0-9]{4}\\s?[0-9]{4}\\s?[0-9]{4}\\s?[0-9]{2}"
        // Create a regular expression object
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return nil
        }
        // Find matches in the string
        let range = NSRange(location: 0, length: self.utf16.count)
        let matches = regex.matches(in: self, options: [], range: range)
        // Check if there is at least one match
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
        return NSLocalizedString(self,
                                 tableName: "Localizable",
                                 bundle: .main,
                                 value: self,
                                 comment: self)
        
    }
}
