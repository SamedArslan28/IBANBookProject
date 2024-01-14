//
//  IbanReaderManager.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 9.12.2023.
//

import Foundation
import UIKit
import MLKitVision
import MLKitTextRecognition

final class IbanReaderManager  {
    func processImage(image: UIImage, completion: @escaping ([String]) -> Void) {
        var foundItems = [String]()
        let visionImage = VisionImage(image: image)
        let textRecognizer = TextRecognizer.textRecognizer(options: TextRecognizerOptions())
        textRecognizer.process(visionImage) { result, error in
            guard error == nil, let result = result else {
                completion([])
                return
            }
            guard !result.blocks.isEmpty else {
                completion([])
                return
            }
            for block in result.blocks {
                for line in block.lines {
                    let lineText = line.text
                    if lineText.isIban() {
                        if let foundIban = lineText.extractIban() {
                            foundItems.append(foundIban)
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                completion(foundItems)
            }
        }
    }
}
