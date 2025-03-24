//
//  CameraSessionVC.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 12.09.2024.
//

import AVFoundation
import UIKit


enum DetectionType {
    case textRecognition
    case qrCode
}

final class CameraSessionVC: BaseVC, Navigable {

    // MARK: - IBOUTLEST

    @IBOutlet private var containerView: UIView!

    // MARK: - PROPERTIES

    private var captureSession: AVCaptureSession?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    var recognitionType: DetectionType?


    // MARK: - LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let data else { return }
        recognitionType = data as? DetectionType
        setupCamera()
        setupCustomBackButton()
        setupTitle()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeCurrentFromStack()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let previewLayer = previewLayer else { return }
        previewLayer.frame = containerView.bounds
    }

    // MARK: - PRIVATE FUNCTIONS

    private func setupTitle() {
        switch recognitionType {
            case .qrCode:
                title = "QR Code"
            case .textRecognition:
                title = "Text Recognition"
            default:
                break
        }
    }

    private func setupCamera() {
        captureSession = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video),
              let captureSession = captureSession else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            showActionAlertCancel(errorTitle: "Error", errorMessage: error.localizedDescription)
            return
        }

        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            showActionAlertCancel(errorTitle: "Error", errorMessage: "Unable to add video input")
            return
        }

        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))

        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        } else {
            showActionAlertCancel(errorTitle: "Error", errorMessage: "Unable to add video input")
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        guard let previewLayer = previewLayer else { return }
        previewLayer.frame = containerView.bounds
        previewLayer.videoGravity = .resizeAspectFill
        containerView.layer.addSublayer(previewLayer)
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession?.startRunning()
        }
    }

    @objc func popToMainVC() {
        popVC()
    }

    private func setupCustomBackButton() {
        let customBackButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"),
                                               style: .plain,
                                               target: self,
                                               action: #selector(popToMainVC))
        navigationItem.leftBarButtonItem = customBackButton
    }

    func stopCameraSession() {
        guard let captureSession = captureSession else { return }
        captureSession.stopRunning()
    }

    func startCameraSession() {
        guard let captureSession else { return }
        captureSession.startRunning()
    }

    func extractBankCode(from iban: String) -> String {
       let trimmedIban = iban.replacingOccurrences(of: " ", with: "")
       let startIndex = trimmedIban.index(iban.startIndex, offsetBy: 4)
       let endIndex = trimmedIban.index(startIndex, offsetBy: 4)
       let bankCode = String(trimmedIban[startIndex...endIndex])
        return turkishBanks[bankCode] ?? ""
   }

    func extractNameFromData(from payload: String) -> String {
       let pattern = "[A-Za-zÇçĞğİıÖöŞşÜü\\s]+(?=\\d)"
       let regex = try? NSRegularExpression(pattern: pattern, options: [])
       let data = payload.removeIban()
       let range = NSRange(location: 0, length: data.utf16.count)
        if let match = regex?.firstMatch(in: data, options: [], range: range) {
           if let nameRange = Range(match.range, in: data) {
               let name = String(data[nameRange])
               return name.trimmingCharacters(in: .whitespaces).lowercased().capitalized
           }
       }
       return ""
   }
}
