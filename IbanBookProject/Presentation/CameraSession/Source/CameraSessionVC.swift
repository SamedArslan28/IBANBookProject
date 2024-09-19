//
//  CameraSessionVC.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 12.09.2024.
//

import AVFoundation
import UIKit
import Vision
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
    let turkishBanks = [
        "00010": "T.C. Ziraat Bankası A.Ş.",
        "00012": "Türkiye Halk Bankası A.Ş.",
        "00046": "Akbank T.A.Ş.",
        "00067": "Yapı ve Kredi Bankası A.Ş.",
        "00062": "Garanti BBVA",
        "00064": "İşbankası A.Ş.",
        "00111": "QNB Finansbank",
        "00134": "Denizbank A.Ş.",
        "00059": "Şekerbank T.A.Ş.",
        "00148": "ING Bank A.Ş.",
        "00032": "TEB Türk Ekonomi Bankası A.Ş.",
        "00210": "Ziraat Katılım Bankası A.Ş.",
        "00206": "Vakıf Katılım Bankası A.Ş.",
        "00200": "Türkiye Emlak Katılım Bankası A.Ş.",
        "00122": "Albaraka Türk Katılım Bankası A.Ş.",
        "00141": "Kuveyt Türk Katılım Bankası A.Ş.",
        "00146": "Türkiye Finans Katılım Bankası A.Ş.",
        "00123": "Alternatifbank A.Ş.",
        "00054": "ICBC Turkey Bank A.Ş.",
        "00109": "Odea Bank A.Ş.",
        "00124": "Burgan Bank A.Ş.",
        "00017": "HSBC Bank A.Ş.",
        "00125": "Anadolu Bank A.Ş.",
        "00205": "Aktif Yatırım Bankası A.Ş.",
        "00145": "Fibabanka A.Ş.",
        "00020": "Citibank A.Ş.",
        "00092": "Turkish Bank A.Ş.",
        "00128": "Türkiye Kalkınma ve Yatırım Bankası A.Ş.",
        "00130": "Dövizbank A.Ş.",
        "00103": "Garan Bank A.Ş.",
        "00102": "İstanbul Bankası A.Ş.",
        "00129": "Ziraat Bankası Kıbrıs",
        "00119": "Kıbrıs Vakıflar Bankası",
        "00127": "Yapı Kredi Bankası Kıbrıs",
        "00126": "Kıbrıs Türk Kooperatif Merkez Bankası",
        "00131": "Kıbrıs Türk Bankası A.Ş.",
        "00132": "Kıbrıs Türk Ziraat Bankası A.Ş.",
        "00133": "Kıbrıs Türk Finans Kurumu A.Ş.",
        "00137": "Ziraat Bankası Azerbaycan",
        "00138": "QNB Finansbank Kıbrıs"
    ]

    // MARK: - LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let data else { return }
        recognitionType = data as? DetectionType
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

    func extractBankCode(from iban: String) -> String {
       let trimmedIban = iban.replacingOccurrences(of: " ", with: "")
       let startIndex = trimmedIban.index(iban.startIndex, offsetBy: 4)
       let endIndex = trimmedIban.index(startIndex, offsetBy: 4)
       let bankCode = String(trimmedIban[startIndex...endIndex])
        return turkishBanks[bankCode] ?? ""
   }

    func extractNameFromData(from payload: String) -> String {
       let pattern = "[A-Za-zÇçĞğİıÖöŞşÜü\\s]+(?=\\d)"
       let regex = try! NSRegularExpression(pattern: pattern, options: [])
       let data = payload.removeIban()
       let range = NSRange(location: 0, length: data.utf16.count)
       if let match = regex.firstMatch(in: data, options: [], range: range) {
           if let nameRange = Range(match.range, in: data) {
               let name = String(data[nameRange])
               return name.trimmingCharacters(in: .whitespaces).lowercased().capitalized
           }
       }
       return ""
   }
}
