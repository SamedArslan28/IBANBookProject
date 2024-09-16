//
//  MainVC+AvCaptureDelegate.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 13.09.2024.
//

import AVFoundation
import UIKit
import Vision

extension MainVC: AVCaptureVideoDataOutputSampleBufferDelegate {

    func processPickedImage(_ image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, orientation: .up, options: [:])
        do {
            try requestHandler.perform([textRecognitionRequest])
            if let results = textRecognitionRequest.results {
                var detectedArray = [String]()
                for observation in results {
                    if let topCandidate = observation.topCandidates(1).first {
                        let detectedText = topCandidate.string
                        if detectedText.isIban() {
                            guard let iban = detectedText.extractIban() else { return }
                            detectedArray.append(iban)
                        }
                    }
                }
                handleOCRResult(detectedArray)
            } else {
                print("No text recognized")
            }
        } catch {
            print("Error performing text recognition on image: \(error)")
        }
    }

    private func handleOCRResult(_ items: [String]) {
        if items.isEmpty {
            showErrorAlert()
        } else if items.count > 1 {
            presentActionSheet(for: items)
        } else {
            pushVC(key: .saveIban, data: items.first)
        }
    }

    private func showErrorAlert() {
        showActionAlertCancel(
            errorTitle: CustomAlertsConstants.errorTitle.localized(),
            errorMessage: CustomAlertsConstants.errorMessage.localized()
        )
    }

    private func presentActionSheet(for items: [String]) {
        let actionSheet = UIAlertController(
            title: CustomAlertsConstants.selectItem.localized(),
            message: nil,
            preferredStyle: .actionSheet
        )
        for item in items {
            let action = UIAlertAction(title: "\(item)", style: .default) { _ in
                self.pushVC(key: .saveIban, data: item)
            }
            actionSheet.addAction(action)
        }
        let cancelAction = UIAlertAction(
            title: CustomAlertsConstants.cancel.localized(),
            style: .cancel,
            handler: nil
        )
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
}
