//
//  CameraSessionVC.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 12.09.2024.
//

import AVFoundation
import UIKit
import Vision

final class CameraSessionVC: BaseVC, Navigable {

    // MARK: - IBOUTLEST

    @IBOutlet private var containerView: UIView!

    // MARK: - PROPERTIES

    private var captureSession: AVCaptureSession?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    lazy var textRecognitionRequest: VNRecognizeTextRequest = {
        let request = VNRecognizeTextRequest()
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        request.recognitionLanguages = ["en"]
        return request
    }()

    // MARK: - LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
        setupCustomBackButton()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let previewLayer = previewLayer else { return}
        previewLayer.frame = containerView.bounds
    }

    // MARK: - PRIVATE FUNCTIONS

    private func setupCamera() {
        captureSession = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video),
              let captureSession = captureSession else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            print("Unable to obtain video input: \(error)")
            return
        }

        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            print("Unable to add video input")
            return
        }

        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))

        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        } else {
            print("Unable to add video output")
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
        guard let navigationController else { return }
        if (navigationController.viewControllers.count) > 2 { popToMain() }
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
}
