//
//  ViewController.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 15.08.2023.
//

import AVFoundation
import MLKitVision
import MLKitTextRecognition
import UIKit
import Vision

final class MainVC: BaseVC, Navigable {

    // MARK: - OUTLETS

    @IBOutlet weak var descriptionLabel: BaseLabel!
    @IBOutlet weak var saveIban: BaseButton!
    @IBOutlet weak var ibanList: BaseButton!
    @IBOutlet weak var readIBANClicked: BaseButton!

    // MARK: - PROPERTIES

    private var imagePicker: UIImagePickerController = UIImagePickerController()
    private var captureSession: AVCaptureSession?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private let textRecognitionRequest = VNRecognizeTextRequest()

    // MARK: - LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        super.setBackground()
        setupUI()
    }

    // MARK: - PRIVATE FUNCTIONS

    private func setupUI(){
        preapreComponents()
        prepareNavBar()
        setupImagePicker()
        prepareSettingsButton()
        setNavigationColor()
        setNavigationTitleColor()
    }

    private func setupImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }

    private func prepareSettingsButton() {
        let settingsButton = UIBarButtonItem(image: UIImage(systemName: "gear"),
                                             style: .plain, target: self,
                                             action: #selector(pushSettingsVC))
        settingsButton.tintColor = .themeColor
        navigationItem.rightBarButtonItem = settingsButton
    }
    
    private func prepareNavBar() {
        guard let navigationController else { return }
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.themeColor]
        navigationController.navigationBar.compactAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        navigationController.navigationBar.standardAppearance = appearance
    }

    private func preapreComponents() {
        descriptionLabel.text = MainConstants.descriptionLabelText.localized()
        saveIban.setTitle(MainConstants.saveIbanButtonTitle.localized(), for: .normal)
        ibanList.setTitle(MainConstants.ibanListButtonTitle.localized(), for: .normal)
        readIBANClicked.setTitle(MainConstants.readIbanButtonTitle.localized(), for: .normal)
    }

    private func configureTextRecognition() {
        textRecognitionRequest.recognitionLevel = .accurate
        textRecognitionRequest.usesLanguageCorrection = true
        textRecognitionRequest.recognitionLanguages = ["en"]
    }

    private func showImagePickerAlert() {
        let alert = UIAlertController(title: CustomAlertsConstants.imagePickerTitle.localized(),
                                      message: CustomAlertsConstants.imagePickerMessage.localized(),
                                      preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: CustomAlertsConstants.cameraPicker.localized(),
                                      style: .default ,
                                      handler: { [weak self] _ in
            self?.setupCamera()

        }))
        alert.addAction(UIAlertAction(title: CustomAlertsConstants.photoLibraryPicker.localized(),
                                      style: .default ,
                                      handler: { [weak self] _ in
            self?.showImagePicker(sourceType: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: CustomAlertsConstants.cancel.localized(), style: .cancel))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }

    private func showImagePicker(sourceType: UIImagePickerController.SourceType) {
        imagePicker.sourceType = sourceType
        DispatchQueue.main.async {
            self.present(self.imagePicker, animated: true, completion: nil)
        }
    }

    private func stopCameraSession() {
        captureSession?.stopRunning()
        previewLayer?.removeFromSuperlayer()
        captureSession = nil
        previewLayer = nil
    }

    private func setupCamera() {
        captureSession = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video),
              let captureSession else { return }
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
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession?.startRunning()
        }
    }


    @objc func pushSettingsVC() {
        pushVC(key: .settings)
    }
    // MARK: - IBACTIONS

    @IBAction private func ibanListTapped(_ sender: Any) {
        pushVC(key: .ibanList)
    }

    @IBAction private func saveIbanTapped(_ sender: Any) {
        pushVC(key: .saveIban)
    }

    @IBAction private func selectPhotoSource(_ sender: BaseButton) {
        DispatchQueue.main.async { [weak self]  in
            self?.showImagePickerAlert()
        }
    }
}

extension MainVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            picker.dismiss(animated: true, completion: nil)
            return
        }
        picker.dismiss(animated: true, completion: nil)
        processPickedImage(image)
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

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate

extension MainVC: AVCaptureVideoDataOutputSampleBufferDelegate {
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
                            print("IBAN found: \(detectedText)")
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

    private func processPickedImage(_ image: UIImage) {
        guard let cgImage = image.cgImage else {
            print("Unable to convert UIImage to CGImage")
            return
        }
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


}
