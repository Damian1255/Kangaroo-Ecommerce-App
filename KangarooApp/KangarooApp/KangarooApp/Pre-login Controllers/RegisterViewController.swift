//
//  RegisterViewController.swift
//  KangarooApp
//
//  Created by Damian on 17/1/22.
//  Copyright © 2022 ITE. All rights reserved.
//

import UIKit
import CoreData

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var phoneTF: UITextField!
    @IBOutlet var firstnameTF: UITextField!
    @IBOutlet var lastnameTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneTF {
            let allowedCharacters = CharacterSet(charactersIn:"+0123456789 ")
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
    
    @IBAction func regNextBtn(_ sender: UIButton) {
        Components.highlightBorder(target: emailTF, duration: 0.3, Width: 2, Color: .clear)
        Components.highlightBorder(target: phoneTF, duration: 0.3, Width: 2, Color: .clear)
        Components.highlightBorder(target: firstnameTF, duration: 0.3, Width: 2, Color: .clear)
        Components.highlightBorder(target: lastnameTF, duration: 0.3, Width: 2, Color: .clear)
        Components.highlightBorder(target: addressTF, duration: 0.3, Width: 2, Color: .clear)
        
        if (emailTF.text == "" || phoneTF.text == "" || firstnameTF.text == "" || lastnameTF.text == "" || addressTF.text == "") {
            if (emailTF.text == ""){
                Components.highlightBorder(target: emailTF, duration: 0.3, Width: 2, Color: .red)
            }
            if (phoneTF.text == ""){
                Components.highlightBorder(target: phoneTF, duration: 0.3, Width: 2, Color: .red)
            }
            if (firstnameTF.text == ""){
                Components.highlightBorder(target: firstnameTF, duration: 0.3, Width: 2, Color: .red)
            }
            if (lastnameTF.text == ""){
                Components.highlightBorder(target: lastnameTF, duration: 0.3, Width: 2, Color: .red)
            }
            if (addressTF.text == ""){
                Components.highlightBorder(target: addressTF, duration: 0.3, Width: 2, Color: .red)
            }
            
            Components.displayMessage(target: errorLabel ,msg: "Please fill in the required fields", duration: 3)
        } else{
            if (Components.isValidEmail(emailTF.text!)){
                performSegue(withIdentifier: "toReg2", sender: nil)
            }else {
                Components.displayMessage(target: errorLabel, msg: "Invalid email address", duration: 3)
                Components.highlightBorder(target: emailTF, duration: 0.3, Width: 2, Color: .red)
            }
        }
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "toReg2" {
            let target = segue.destination as! RegisterViewController2
            
            target.firstname = firstnameTF.text!
            target.lastname = lastnameTF.text!
            target.email = emailTF.text!
            target.phone = Int(phoneTF.text!)!
            target.address = addressTF.text!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneTF.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}

class RegisterViewController2: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var firstname = String()
    var lastname = String()
    var email = String()
    var phone = Int()
    var address = String()
    var checked = false
    
    var imagePicker = UIImagePickerController()
    
    @IBOutlet var usernameTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
    @IBOutlet weak var cfmpasswordTF: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var Userimage: UIButton!
    
    let app = UIApplication.shared.delegate as! AppDelegate
    var viewContext: NSManagedObjectContext!
    
    @IBAction func noobNatelie(_ sender: CustomButtons) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false

            present(imagePicker, animated: true, completion: nil)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            Userimage.setImage(image, for: .normal)
            
            let user = NSEntityDescription.insertNewObject(forEntityName: "Users", into: viewContext) as! Users
            user.userImage = image.pngData()
        }
    }
    
    @IBAction func pwdVisibility(_ sender: UIButton) {
        if (passwordTF.isSecureTextEntry) {
            passwordTF.isSecureTextEntry = false
            cfmpasswordTF.isSecureTextEntry = false
            sender.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        } else{
            passwordTF.isSecureTextEntry = true
            cfmpasswordTF.isSecureTextEntry = true
            sender.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        }
    }

    @IBAction func tick(sender: UIButton) {
        if !checked {
            sender.setImage(UIImage(systemName:"checkmark"), for: .normal)
            checked = true
        }
        else {
            sender.setImage(UIImage(systemName:""), for: .normal)
            checked = false
        }
    }
    
    @IBAction func registerooBtn(_ sender: Any) {
        Components.highlightBorder(target: usernameTF, duration: 0.3, Width: 2, Color: .clear)
        Components.highlightBorder(target: passwordTF, duration: 0.3, Width: 2, Color: .clear)
        Components.highlightBorder(target: cfmpasswordTF, duration: 0.3, Width: 2, Color: .clear)
        
        if (usernameTF.text == "" || passwordTF.text == "" || cfmpasswordTF.text == ""){
            if (usernameTF.text == ""){
                Components.highlightBorder(target: usernameTF, duration: 0.3, Width: 2, Color: .red)
            }
            if (passwordTF.text == ""){
                Components.highlightBorder(target: passwordTF, duration: 0.3, Width: 2, Color: .red)
            }
            if (cfmpasswordTF.text == ""){
                Components.highlightBorder(target: cfmpasswordTF, duration: 0.3, Width: 2, Color: .red)
            }
            
            Components.displayMessage(target: errorLabel, msg: "Please fill in the required fields", duration: 3)	
        }
        else {
            viewContext = app.persistentContainer.viewContext
            
            let fetch: NSFetchRequest = Users.fetchRequest()
            let predicate = NSPredicate(format: "username == %@", usernameTF.text!)
            fetch.predicate = predicate
            
            do {
                let username = try viewContext.fetch(fetch)
                if username.count > 0 {
                    Components.displayMessage(target: errorLabel, msg: "Username already exist", duration: 3)
                    Components.highlightBorder(target: usernameTF, duration: 0.3, Width: 2, Color: .red)
                } else {
                    if (passwordTF.text == cfmpasswordTF.text) {
                        if (checked){
                            registerUser()
                        } else {
                            Components.displayMessage(target: errorLabel, msg: "tick to register", duration: 3)
                        }
                    } else {
                        Components.displayMessage(target: errorLabel, msg: "Passwords does not match", duration: 3)
                        Components.highlightBorder(target: passwordTF, duration: 0.3, Width: 2, Color: .red)
                        Components.highlightBorder(target: cfmpasswordTF, duration: 0.3, Width: 2, Color: .red)
                    }
                }
            } catch {
                print(error)
            }
        }
    }
    
    func registerUser() {
        let user = NSEntityDescription.insertNewObject(forEntityName: "Users", into: viewContext) as! Users
        
        user.firstName = firstname.capitalized
        user.lastName = lastname.capitalized
        user.phoneNo = Int32(phone)
        user.emailAddress = email
        user.address = address
        user.username = usernameTF.text
        user.password = passwordTF.text
        user.credits = 200
        user.userDiscounts = 3
        user.wishlistItems = []
        user.cartItems = [[]]
        user.orderHistory = [[]]
        user.userImage = Userimage.currentImage?.pngData()
        
        app.saveContext()
        print("User Data Created with username: " + usernameTF.text!)
        
        let alert = UIAlertController(title: "Welcome, \(firstname)", message: "Your account has been succesfully registered.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {
            action in self.performSegue(withIdentifier: "toMain", sender: self)
        }))
        
        self.present(alert, animated: true)
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewContext = app.persistentContainer.viewContext
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        
    }
}
