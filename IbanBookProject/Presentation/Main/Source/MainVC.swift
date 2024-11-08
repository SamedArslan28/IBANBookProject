//
//  ViewController.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 15.08.2023.
//

import UIKit
import Vision
import AVFoundation
import Photos

final class MainVC: BaseVC, Navigable {

    // MARK: - OUTLETS

    @IBOutlet weak var descriptionLabel: BaseLabel!
    @IBOutlet weak var saveIban: BaseButton!
    @IBOutlet weak var ibanList: BaseButton!
    @IBOutlet weak var readIBANClicked: BaseButton!

    // MARK: - PROPERTIES

    private lazy var imagePicker: UIImagePickerController = UIImagePickerController()

    lazy var textRecognitionRequest: VNRecognizeTextRequest = {
        let request = VNRecognizeTextRequest()
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        request.recognitionLanguages = [MainConstants.recognitionLanguage]
        return request
    }()

    // MARK: - LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        super.setBackground()
        setupUI()
    }

    // MARK: - PRIVATE FUNCTIONS

    private func setupUI() {
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
        let settingsButton = UIBarButtonItem(image: UIImage(systemName: MainConstants.settingButtonIcon),
                                             style: .plain,
                                             target: self,
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

    private func showImagePickerAlert() {
        let alert = UIAlertController(title: CustomAlertsConstants.imagePickerTitle.localized(),
                                      message: CustomAlertsConstants.imagePickerMessage.localized(),
                                      preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: CustomAlertsConstants.cameraPicker.localized(),
                                      style: .default ,
                                      handler: { [weak self] _ in
            self?.checkCameraAccessAndProceed(detectionType: .textRecognition)
        }))
        alert.addAction(UIAlertAction(title: CustomAlertsConstants.qrPicker.localized(),
                                      style: .default ,
                                      handler: { [weak self] _ in
            self?.checkCameraAccessAndProceed(detectionType: .qrCode)
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

    private func checkCameraAccessAndProceed(detectionType: DetectionType) {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)

        switch cameraAuthorizationStatus {
        case .authorized:
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.pushVC(key: .camera, data: detectionType)
            }
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        if UIImagePickerController.isSourceTypeAvailable(.camera) {
                            self.pushVC(key: .camera, data: detectionType)
                        }
                    }
                }
            }
        case .denied, .restricted:
            showCameraAccessDeniedAlert()
        @unknown default:
            break
        }
    }

    private func showCameraAccessDeniedAlert() {
        let alertController = UIAlertController(
            title: MainConstants.accessDeniedTitle.localized(),
            message: MainConstants.accessDeniedMessage.localized(),
            preferredStyle: .alert)
        alertController.addAction(UIAlertAction(
            title: MainConstants.settings.localized(),
            style: .default) { _ in
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsURL) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        })
        alertController.addAction(UIAlertAction(title: CustomAlertsConstants.cancel.localized(), style: .cancel, handler: nil))

        present(alertController, animated: true, completion: nil)
    }

}
