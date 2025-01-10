import Foundation
import Vision
import AVFoundation

extension CameraSessionVC: AVCaptureVideoDataOutputSampleBufferDelegate {

    /// Called when the camera outputs a sample buffer, handling both QR code and text recognition.
    /// - Parameters:
    ///   - output: The capture output that provides the sample buffer.
    ///   - sampleBuffer: The sample buffer from the video output.
    ///   - connection: The connection from which the sample buffer originates.
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        let requestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer,
                                                   orientation: .right,
                                                   options: [:])

        switch recognitionType {
        case .qrCode:
            /// Handles QR code recognition by configuring a barcode detection request.
            let barcodeRequest = VNDetectBarcodesRequest { (request, error) in
                if let results = request.results as? [VNBarcodeObservation] {
                    for result in results {
                        if let payloadString = result.payloadStringValue {
                            guard let data = self.processDataFromQR(payload: payloadString) else { return }
                            self.stopCameraSession()
                            DispatchQueue.main.async {
                                self.pushVC(key: .saveIban, data: data)
                            }
                            return
                        }
                    }
                }
            }
            barcodeRequest.symbologies = [.qr]
            do {
                try requestHandler.perform([barcodeRequest])
            } catch {
                print("Error performing barcode request: \(error)")
            }

        case .textRecognition:
            /// Handles text recognition, specifically detecting IBAN codes in the recognized text.
            let textRecognitionRequest = VNRecognizeTextRequest { (request, error) in
                if let results = request.results as? [VNRecognizedTextObservation] {
                    for observation in results {
                        if let topCandidate = observation.topCandidates(1).first {
                            let detectedIban = topCandidate.string
                            if detectedIban.isIban() {
                                self.stopCameraSession()
                                DispatchQueue.main.async {
                                    self.pushVC(key: .saveIban, data: self.proccessIbanData(detectecIban: detectedIban))
                                }
                                return
                            }
                        }
                    }
                }
            }
            textRecognitionRequest.recognitionLevel = .accurate
            textRecognitionRequest.usesLanguageCorrection = true
            textRecognitionRequest.recognitionLanguages = ["tr", "en"]
            do {
                try requestHandler.perform([textRecognitionRequest])
            } catch {
                print("Error performing text recognition request: \(error)")
            }
        case .none:
            break
        }
    }

    /// Processes data from a QR code payload string, extracting the IBAN and related data.
    /// - Parameter payload: The raw string payload from the QR code.
    /// - Returns: An optional `IbanDataModel` if a valid IBAN is found; otherwise, `nil`.
    private func processDataFromQR(payload: String) -> IbanDataModel? {
        guard let iban = payload.extractIban() else {
            DispatchQueue.main.async {
                self.showActionAlertCancel(
                    errorTitle: CameraSessionConstants.invalidQrTitle.localized(),
                    errorMessage: CameraSessionConstants.invalidQrMessage.localized()
                )
            }
            return nil
        }
        let bankName = extractBankCode(from: iban)
        let name = extractNameFromData(from: payload)
        return IbanDataModel(bankName: bankName, iban: iban, name: name)
    }

    /// Processes an IBAN string detected from text recognition.
    /// - Parameter detectecIban: The detected IBAN string.
    /// - Returns: An `IbanDataModel` instance containing the bank name and IBAN.
    private func proccessIbanData(detectecIban: String) -> IbanDataModel {
        let iban = detectecIban.extractIban() ?? ""
        let bankName = extractBankCode(from: iban)
        return IbanDataModel(bankName: bankName, iban: iban)
    }
}
