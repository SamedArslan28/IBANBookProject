//
//  StringExtensions.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 27.10.2023.
//

import Foundation
import UIKit


//regex for detecting IBAN number with space or without space
// /\b[A-Z]{2}[0-9]{2}(?:[ ]?[0-9]{4}){4}(?!(?:[ ]?[0-9]){3})(?:[ ]?[0-9]{1,2})?\b/gm


extension String {
    func isIban() -> Bool {
        let regexPattern = #"TR[0-9]{2}\s?[0-9]{4}\s?[0-9]{4}\s?[0-9]{4}\s?[0-9]{4}\s?[0-9]{2}"#

        do {
            // Create an NSRegularExpression object
            let regex = try NSRegularExpression(pattern: regexPattern, options: [])

            let range = NSRange(location: 0, length: self.utf16.count)

            if let _ = regex.firstMatch(in: self, options: [], range: range) {
                print("String matches the regex.")
            } else {
                print("String does not match the regex.")
            }
        } catch {
            
            print("Invalid regular expression: \(error.localizedDescription)")
        }
        return false

    }

}
