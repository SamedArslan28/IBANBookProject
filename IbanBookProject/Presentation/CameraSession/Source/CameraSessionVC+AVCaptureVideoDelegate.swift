//
//  CameraSessionVC+AVCaptureVideoDelegate.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 13.09.2024.
//

import Foundation
import Vision
import AVFoundation

extension CameraSessionVC: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        var detectedArray = [String]()
        let requestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .right, options: [:])

        do {
            try requestHandler.perform([textRecognitionRequest])
            if let results = textRecognitionRequest.results {
                for observation in results {
                    if let topCandidate = observation.topCandidates(1).first {
                        let detectedText = topCandidate.string
                        if detectedText.isIban() {
                            detectedArray.append(detectedText)
                            self.stopCameraSession()
                            DispatchQueue.main.sync {
                                self.pushVC(key: .saveIban, data: detectedText.extractIban())
                            }
                            return
                        }
                    }
                }
            }
        } catch {
            print("Error performing text recognition: \(error)")
        }
    }
}
