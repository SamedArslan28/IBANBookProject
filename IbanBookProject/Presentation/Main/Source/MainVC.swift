//
//  ViewController.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 15.08.2023.
//

import UIKit

final class MainVC: BaseVC, UINavigationControllerDelegate {
    @IBOutlet weak var descriptionLabel: BaseLabel!
    
    @IBOutlet weak var saveIban: BaseButton!
    @IBOutlet weak var ibanList: BaseButton!
    @IBOutlet weak var readIBANclicked: BaseButton!

    let imagePickerItem = UIImagePickerController()


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        descriptionLabel.text = "Iban Defteri uygulaması sayesinde Iban`larınızı telefon kameranızla ya da galerinizdeki resimden okuyabilirsiniz. \n\n Aynı zamanda Iban'ları kolayca kaydedebilir ve yakınlarınızla paylaşabilirsiniz."

        saveIban.setTitle("IBAN Kaydet", for: .normal)
        ibanList.setTitle("IBAN Defteri", for: .normal) 
        readIBANclicked.setTitle("IBAN Oku", for: .normal)
        imagePickerItem.delegate = self



    }


    @IBAction func selectPhotoSource(_ sender: BaseButton) {
        let alert = UIAlertController(title: "Kaynak Seciniz", message: "Iban nereden okunacak ?", preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Kamera", style: .default , handler:{ _ in

            self.imagePickerItem.sourceType = .camera


            self.present(self.imagePickerItem, animated: true)
        }))


        alert.addAction(UIAlertAction(title: "Fotograflar", style: .default , handler:{ (UIAlertAction)in
            
            self.imagePickerItem.sourceType = .photoLibrary
            self.present(self.imagePickerItem,animated: true)


        }))

        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true)
    }
}


extension UIViewController: UIImagePickerControllerDelegate{

    func imagePicker(sourceType: UIImagePickerController.SourceType) -> UIImagePickerController{
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType

        return imagePicker
    }


}

