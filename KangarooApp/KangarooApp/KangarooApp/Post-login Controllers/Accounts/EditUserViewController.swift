//
//  EditUserViewController.swift
//  KangarooApp
//
//  Created by Damian on 25/2/22.
//  Copyright © 2022 ITE. All rights reserved.
//

import UIKit
import CoreData

class EditUserViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let app = UIApplication.shared.delegate as! AppDelegate
    var viewContext: NSManagedObjectContext!
    let username = UserDefaults.standard.string(forKey: "User")!
    var imagePicker = UIImagePickerController()
    
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var imageView: UIButton!
       
    @IBAction func SaveBtn(_ sender: UIButton) {
        Components.highlightBorder(target: firstNameTF, duration: 0.3, Width: 2, Color: .clear)
        Components.highlightBorder(target: lastNameTF, duration: 0.3, Width: 2, Color: .clear)
        Components.highlightBorder(target: emailTF, duration: 0.3, Width: 2, Color: .clear)
        Components.highlightBorder(target: addressTF, duration: 0.3, Width: 2, Color: .clear)
        Components.highlightBorder(target: phoneTF, duration: 0.3, Width: 2, Color: .clear)

        if (firstNameTF.text == "" || lastNameTF.text == "" || emailTF.text == "" || addressTF.text == "" || phoneTF.text == ""){
            if (firstNameTF.text == ""){
                Components.highlightBorder(target: firstNameTF, duration: 0.3, Width: 2, Color: .red)
            }
            if (lastNameTF.text == ""){
                Components.highlightBorder(target: lastNameTF, duration: 0.3, Width: 2, Color: .red)
            }
            if (emailTF.text == ""){
                Components.highlightBorder(target: emailTF, duration: 0.3, Width: 2, Color: .red)
            }
            if (addressTF.text == ""){
                Components.highlightBorder(target: addressTF, duration: 0.3, Width: 2, Color: .red)
            }
            if (phoneTF.text == ""){
                Components.highlightBorder(target: phoneTF, duration: 0.3, Width: 2, Color: .red)
            }
                   
            Components.displayMessage(target: errorLabel, msg: "Please fill in the required fields", duration: 3)
        }
        else {
            if (Components.isValidEmail(emailTF.text!)){
                saveData()
                
                let alert = UIAlertController(title: "Saved", message: "Your information has been updated", preferredStyle: UIAlertController.Style.alert)

                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (actionSheetController) -> Void in
                    self.performSegue(withIdentifier: "backToAccount", sender: nil)
                }))
                
                present(alert, animated: true, completion: nil)
            } else {
                Components.highlightBorder(target: emailTF, duration: 0.3, Width: 2, Color: .red)
                Components.displayMessage(target: errorLabel, msg: "Invald Email", duration: 3)
            }
        }
    }
    
    func saveData() {
        do {
            let all = try viewContext.fetch(Users.fetchRequest())
            for user in all as! [Users] {
                if (user.username == username){
                    user.firstName = firstNameTF.text
                    user.lastName = lastNameTF.text
                    user.emailAddress = emailTF.text
                    user.address = addressTF.text
                    user.phoneNo = Int32(phoneTF.text!)!
                    user.userImage = imageView!.currentBackgroundImage!.pngData()
                }
            }
            app.saveContext()
        } catch {}
    }
    
    func getUserInfo(username: String) {
        do {
            let all = try viewContext.fetch(Users.fetchRequest())
            for user in all as! [Users] {
                if (user.username == username){
                    firstNameTF.text = String(user.firstName!)
                    lastNameTF.text = String(user.lastName!)
                    emailTF.text = String(user.emailAddress!)
                    addressTF.text = String(user.address!)
                    phoneTF.text = String(user.phoneNo)
                    imageView.setBackgroundImage(UIImage(data: user.userImage!), for: .normal)
                }
            }
        } catch {}
           print("wishlist loaded")
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.setBackgroundImage(image, for: .normal)
            
            
            let user = NSEntityDescription.insertNewObject(forEntityName: "Users", into: viewContext) as! Users
            user.userImage = image.pngData()
        }
    }
    
    @IBAction func noobNatelie(_ sender: CustomButtons) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false

            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneTF {
            let allowedCharacters = CharacterSet(charactersIn:"+0123456789 ")
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewContext = app.persistentContainer.viewContext
        phoneTF.delegate = self as? UITextFieldDelegate
        
        getUserInfo(username: username)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
