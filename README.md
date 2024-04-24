# IBANBookProject
Swift IBAN Book Project, makes saving and sharing IBAN easier.

## Description

IBAN Reader is a project designed to simplify the process of extracting International Bank Account Numbers (IBANs) from images. Whether you're dealing with scanned documents, photographs, or screenshots, IBAN Reader automates the extraction process, making it easier to manage and share IBAN information

## Getting Started

1. Make sure you have the Xcode version 15.0 or above installed on your computer.
2. Download the Iban Book project files from the repository.
3. Install CocoaPods.
4. Run pod install so you can install the dependencies in your project.
5. Open the project files in Xcode.
6. Review the code and make sure you understand what it does.
7. Run the active scheme.

## Architecture
The IBAN Reader project follows the MVVM (Model-View-ViewModel) architecture pattern along with a custom navigation system based on coordinators. Below is an overview of each component:

* Coordinator.swift
This file contains the Coordinator class, which is responsible for managing navigation within the application. Coordinators help to separate navigation logic from view controllers, promoting better organization and testability.

* ControllerKey Enumeration
The ControllerKey enumeration defines keys for different view controllers in the application. Each key is associated with a specific view controller type, facilitating navigation.

* Navigable Protocol and UIViewController Extension
The Navigable protocol defines navigation methods that view controllers can conform to. These methods include pushing, presenting, popping, and dismissing view controllers. The UIViewController extension provides default implementations for these navigation methods, allowing view controllers to navigate within the application using predefined keys and optional data.

* ControllerFactory
The ControllerFactory class is responsible for creating view controllers based on their corresponding keys. It utilizes the keys defined in the ControllerKey enumeration to instantiate the appropriate view controller types, promoting modular and maintainable code.

This architecture promotes separation of concerns, maintainability, and testability by abstracting away the details of view controller instantiation and navigation logic. By following the MVVM pattern, business logic is decoupled from the user interface, making the codebase easier to understand and maintain.

## Structure
The IBAN Reader project follows a well-organized folder structure to maintain clarity and modularity. Below is an overview of the main folders:

### Common
The Common folder contains shared components and utilities used throughout the project. It includes:

- Extensions: Extensions on built-in Swift types and UIKit classes to provide additional functionality or convenience methods.
- Coordinator: Implementation of the coordinator pattern for managing navigation flow within the application.
- Base Views: Base classes or protocols for view controllers, views, or other UI components to encapsulate common functionality and promote code reuse.
- Managers: Classes responsible for managing application-wide tasks or resources, such as network requests, data caching, or user authentication.

### Application
The Application folder houses classes directly related to the application lifecycle and scene management. It includes:

- Scenes: Each scene folder contains view controllers, view models, and views specific to a particular feature or screen in the application. This promotes modular development and encapsulation of related functionality.
- App Delegate: The AppDelegate.swift file contains the main application delegate class responsible for handling system events and configuring the initial application state.

### Presentation
The Presentation folder contains folders for each view in the application, along with their respective XIB files, view controllers, and constants files. It includes:

- View Folders: Each view folder represents a specific UI component or screen in the application. It contains the following files:
- ViewNameViewController.swift: The view controller responsible for handling the logic and behavior of the corresponding view.
- ViewNameView.xib: The Interface Builder file defining the layout and appearance of the view.
- ViewNameConstants.swift: Constants specific to the view, such as layout constraints, colors, or strings.

### Resources
The Resources folder contains various resources used by the application, including:

- Plist Files: Property list files (plist) used for storing configuration data or other structured information.
- Asset Catalog: The asset catalog (xcassets) containing image assets, app icons, and other graphical resources used in the application.
- Localization Files: Files (strings) for localization and internationalization of the application's user interface strings.

## Dependencies
IBAN Reader utilizes the following dependencies, managed via CocoaPods:

Firebase Analytics: Firebase Analytics is integrated into the project to provide insights into user behavior and app performance.

Google ML Kit - Text Recognition: Google ML Kit's Text Recognition module is used for optical character recognition (OCR) to extract text from images, enabling IBAN extraction functionality.

Ensure that you have CocoaPods installed on your system, and run pod install in your project directory to install these dependencies.
