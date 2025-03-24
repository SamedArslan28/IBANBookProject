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
                showActionAlertCancel(errorTitle: "Error",
                                      errorMessage: "No tet recognized")
            }
        } catch {
            showActionAlertCancel(errorTitle: "Error",
                                  errorMessage: error.localizedDescription)
        }
    }

    private func handleOCRResult(_ items: [String]) {
        switch items.count {
        case 0:
            showErrorAlert()
        case 1:
            pushVC(key: .saveIban, data: items.first)
        default:
            presentActionSheet(for: items)
        }
    }

    private func showErrorAlert() {
        showActionAlertCancel(
            errorTitle: CustomAlertsConstants.errorTitle.localized(),
            errorMessage: CustomAlertsConstants.errorMessage.localized()
        )
    }

    private func presentActionSheet(for ibans: [String]) {
        let actionSheet = UIAlertController(
            title: CustomAlertsConstants.selectItem.localized(),
            message: nil,
            preferredStyle: .actionSheet
        )
        for iban in ibans {
            let action = UIAlertAction(title: "\(iban)", style: .default) { _ in
                let bankName = iban.extractBankCode()
                let ibanData = IbanDataModel(bankName: bankName, iban: iban, name: "")
                self.pushVC(key: .saveIban, data: ibanData)
            }
            actionSheet.addAction(action)
        }
        let cancelAction = UIAlertAction(
            title: CustomAlertsConstants.cancel.localized(),
            style: .cancel,
            handler: nil
        )
        actionSheet.addAction(cancelAction)
        self.present(actionSheet,
                     animated: true,
                     completion: nil)
    }
}
