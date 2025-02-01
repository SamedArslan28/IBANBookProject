import UIKit
import Vision
import AVFoundation
import Photos

final class MainVC: BaseVC, Navigable {

    // MARK: - Outlets

    @IBOutlet weak var descriptionLabel: BaseLabel!
    @IBOutlet weak var readIbanButton: BaseButton!
    @IBOutlet weak var ibanListButton: BaseButton!
    @IBOutlet weak var saveIbanButton: BaseButton!

    // MARK: - Properties

    private lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        return picker
    }()

    lazy var textRecognitionRequest: VNRecognizeTextRequest = {
        let request = VNRecognizeTextRequest()
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        request.recognitionLanguages = [MainConstants.recognitionLanguage]
        return request
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        setupUI()
    }

    // MARK: - UI Setup

    private func setupUI() {
        configureNavigationBar()
        setupLanguageMenu()
        configureComponents()
    }

    private func configureNavigationBar() {
        guard let navigationController else { return }
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.themeColor]
        navigationController.navigationBar.compactAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.tintColor = .themeColor
        navigationItem.titleView?.tintColor = .themeColor
    }

    private func setupLanguageMenu() {
        let languageButton = UIBarButtonItem(image: UIImage(systemName: "globe")?.withTintColor(.themeColor,
                                                                                                renderingMode: .alwaysOriginal),
                                             style: .plain,
                                             target: nil,
                                             action: nil)
        languageButton.tintColor = .label
        languageButton.menu = createLanguageMenu()
        navigationItem.rightBarButtonItem = languageButton
    }

    private func configureComponents() {
        descriptionLabel.text = MainConstants.descriptionLabelText.localized()
        saveIbanButton.setTitle(MainConstants.saveIbanButtonTitle.localized(), for: .normal)
        ibanListButton.setTitle(MainConstants.ibanListButtonTitle.localized(), for: .normal)
        readIbanButton.setTitle(MainConstants.readIbanButtonTitle.localized(), for: .normal)
    }

    // MARK: - Language Handling

    private func createLanguageMenu() -> UIMenu {
        let availableLanguages = ["en", "tr"]
        let menuItems = availableLanguages.map { languageCode in
            UIAction(title: "\(flagEmoji(for: languageCode)) \(Locale.current.localizedString(forLanguageCode: languageCode) ?? languageCode)",
                     handler: { _ in self.changeLanguage(to: languageCode) })
        }
        return UIMenu(title: "Choose Language", children: menuItems)
    }

    private func changeLanguage(to languageCode: String) {
        guard CacheManager.shared.getString(key: "languageCode") != languageCode else { return }
        CacheManager.shared.setObject(languageCode, key: "languageCode")
        UserDefaults.standard.setValue(languageCode, forKey: "languageCode")
        restartApplication()
    }

    private func flagEmoji(for languageCode: String) -> String {
        let countryCode = ["en": "US",
                           "tr": "TR"][languageCode] ?? "TR"
        return countryCode.unicodeScalars.compactMap { UnicodeScalar(127397 + $0.value) }.map { String($0) }.joined()
    }

    // MARK: - Image Picker

    private func showImagePickerAlert() {
        let alert = UIAlertController(title: CustomAlertsConstants.imagePickerTitle.localized(),
                                      message: CustomAlertsConstants.imagePickerMessage.localized(),
                                      preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: CustomAlertsConstants.cameraPicker.localized(), style: .default) { _ in
            self.checkCameraAccessAndProceed(detectionType: .textRecognition)
        })

        alert.addAction(UIAlertAction(title: CustomAlertsConstants.qrPicker.localized(), style: .default) { _ in
            self.checkCameraAccessAndProceed(detectionType: .qrCode)
        })

        alert.addAction(UIAlertAction(title: CustomAlertsConstants.photoLibraryPicker.localized(), style: .default) { _ in
            self.showImagePicker(sourceType: .photoLibrary)
        })

        alert.addAction(UIAlertAction(title: CustomAlertsConstants.cancel.localized(), style: .cancel))

        present(alert, animated: true)
    }

    private func showImagePicker(sourceType: UIImagePickerController.SourceType) {
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true)
    }

    private func checkCameraAccessAndProceed(detectionType: DetectionType) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                pushVC(key: .camera, data: detectionType)
            }
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        self.pushVC(key: .camera, data: detectionType)
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
        let alert = UIAlertController(title: MainConstants.accessDeniedTitle.localized(),
                                      message: MainConstants.accessDeniedMessage.localized(),
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: MainConstants.settings.localized(), style: .default) { _ in
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(settingsURL)
        })

        alert.addAction(UIAlertAction(title: CustomAlertsConstants.cancel.localized(), style: .cancel))
        present(alert, animated: true)
    }

    // MARK: - Actions

    @IBAction private func ibanListTapped(_ sender: Any) {
        pushVC(key: .ibanList)
    }

    @IBAction private func saveIbanTapped(_ sender: Any) {
        pushVC(key: .saveIban)
    }

    @IBAction private func selectPhotoSource(_ sender: BaseButton) {
        showImagePickerAlert()
    }
}
