# IBANBookProject

<p align="center">
  <img src="https://img.shields.io/badge/Swift-5.0%2B-orange" alt="Swift 5.0+">
  <img src="https://img.shields.io/badge/Xcode-15.0%2B-blue" alt="Xcode 15.0+">
  <img src="https://img.shields.io/badge/Platform-iOS-lightgrey" alt="Platform iOS">
</p>

<p align="center">
  <img src="/.github/assets/app-demo.gif" width="300" alt="IBANBookProject Demo GIF">
</p>

IBANBookProject is a Swift-based iOS app designed to simplify extracting International Bank Account Numbers (IBANs) from images. Whether you're dealing with scanned documents, photographs, or screenshots, this app automates the extraction process, making it easier to manage and share IBAN information.

## ✨ Features

* 📸 **Scan IBANs:** Use your camera to instantly capture and extract IBANs from paper.
* 🖼️ **Import from Photos:** Select any image or screenshot from your photo library to read an IBAN.
* 📋 **One-Tap Copy:** Easily copy the extracted IBAN to your clipboard.
* 📤 **Share:** Share the IBAN string directly to other apps (Notes, Messages, etc.).
* 💾 **Save:** Store and name your scanned IBANs for future use.

<p align="center">
    <img src="/.github/screenshot-scan.png" width="200" alt="Scanning Feature">
  &nbsp;&nbsp;&nbsp;&nbsp;
    <img src="/.github/screenshot-list.png" width="200" alt="Share Feature">
  &nbsp;&nbsp;&nbsp;&nbsp;
    <img src="/.github/screenshot-scan.png" width="200" alt="Saved IBANs List">

</p>

## 💻 Tech Stack & Architecture

This project is built natively for iOS using the following technologies and patterns:

* **Language:** **Swift**
* **UI:** **UIKit** (based on your `UIViewController` mentions)
* **Text Recognition:** **VisionKit** (for live and static image text detection)
* **Architecture:** **MVVM-C (Model-View-ViewModel-Coordinator)**
* **Navigation:** Custom **Coordinator** pattern to manage navigation flow.

The project follows the MVVM architecture along with a custom navigation system based on coordinators.

* **Coordinator.swift:** Manages navigation within the application, separating navigation logic from view controllers.
* **ControllerKey:** An enumeration that defines keys for different view controllers, facilitating decoupled navigation.
* **Navigable Protocol:** A protocol that view controllers conform to, providing a clean API for navigation (push, present, pop, etc.).
* **ControllerFactory:** Responsible for creating view controller instances based on their `ControllerKey`, promoting modularity.

This architecture promotes a strong separation of concerns, high testability, and a maintainable codebase.

## 🚀 Getting Started

### Prerequisites

* macOS with **Xcode 15.0** or later.
* An iOS device or Simulator.

### Installation

1.  Clone the repository:
    ```sh
    git clone [https://github.com/your-username/IBANBookProject.git](https://github.com/your-username/IBANBookProject.git)
    ```
2.  Navigate to the project directory:
    ```sh
    cd IBANBookProject
    ```
3.  Open the `.xcodeproj` or `.xcworkspace` file in Xcode:
    ```sh
    open IbanBook.xcodeproj 
    ```
4.  If you have any dependencies (like CocoaPods or Swift Package Manager), install them.
    * **SPM:** Dependencies should resolve automatically in Xcode.
    * **CocoaPods:** Run `pod install` from the terminal.

5.  Select your target device and run the active scheme (Product > Run or `Cmd+R`).

## 📂 Project Structure

The project follows a clean folder structure to maintain clarity and modularity:

* **Application/**: Contains the `AppDelegate`, `SceneDelegate`, and the main **Coordinator** logic.
* **Common/**: Shared components and utilities like `BaseViews`, `Extensions`, and `Managers`.
* **Scenes/** (or Presentation/): Contains the individual screens of the app. Each scene has its own folder containing:
    * `ViewNameViewController.swift`
    * `ViewNameViewModel.swift`
    * `ViewNameView.xib`
    * `ViewNameConstants.swift`
* **Resources/**: Contains all non-code assets, such as `Assets.xcassets`, `Info.plist`, and localization files.

## 🗺️ Roadmap

We have plans to make IBANBookProject even better!

* [ ] iCloud synchronization across devices.
* [ ] Add support for validating IBAN checksums.
* [ ] Batch import/scan multiple images at once.
* [ ] Localize the app into more languages.
