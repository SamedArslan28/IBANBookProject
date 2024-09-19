import Foundation
import Vision
import AVFoundation

extension CameraSessionVC: AVCaptureVideoDataOutputSampleBufferDelegate {
       func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
           guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
           let requestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer,
                                                      orientation: .right,
                                                      options: [:])

           switch recognitionType {
           case .qrCode:
               let barcodeRequest = VNDetectBarcodesRequest { (request, error) in
                   if let results = request.results as? [VNBarcodeObservation] {
                       for result in results {
                           if let payloadString = result.payloadStringValue {
                               guard let data = self.processDataFromQR(payload: payloadString) else { return }
                               self.stopCameraSession()
                               DispatchQueue.main.async {
                                   self.pushVC(key: .saveIban,
                                               data: data)
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
               let textRecognitionRequest = VNRecognizeTextRequest { (request, error) in
                   if let results = request.results as? [VNRecognizedTextObservation] {
                       for observation in results {
                           if let topCandidate = observation.topCandidates(1).first {
                               let detectedIban = topCandidate.string
                               if detectedIban.isIban() {
                                   self.stopCameraSession()
                                   DispatchQueue.main.async {
                                       self.pushVC(key: .saveIban,
                                                   data: self.proccessIbanData(detectecIban: detectedIban))
                                   }
                                   return
                               }
                           }
                       }
                   }
               }
               textRecognitionRequest.recognitionLevel = .accurate
               textRecognitionRequest.usesLanguageCorrection = true
               do {
                   try requestHandler.perform([textRecognitionRequest])
               } catch {
                   print("Error performing text recognition request: \(error)")
               }
           case .none:
               break
           }
       }

    private func processDataFromQR(payload: String) -> IbanDataModel? {
        guard let iban = payload.extractIban()
        else {
            DispatchQueue.main.async {
                self.showActionAlertCancel(errorTitle: "Invalid QR Code", errorMessage: "Please scan a valid QR Code")
            }
            return nil
        }
        let bankName = extractBankCode(from: iban)
        let name = extractNameFromData(from: payload)
        return IbanDataModel(bankName: bankName, iban: iban, name: name)
    }

    private func proccessIbanData(detectecIban: String) -> IbanDataModel {
        let iban = detectecIban.extractIban() ?? ""
        let bankName = extractBankCode(from: iban)
        return IbanDataModel(bankName: bankName, iban: iban)
    }

}

final class IbanDataModel {
    let bankName: String
    let iban: String
    let name: String

    init (
        bankName: String = "",
        iban: String = "",
        name: String = ""
    )
    {
        self.bankName = bankName
        self.iban = iban
        self.name = name
    }
}
