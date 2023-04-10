//
//  ForgetPasswordViewController.swift
//  KangarooApp
//
//  Created by Damian on 18/1/22.
//  Copyright © 2022 ITE. All rights reserved.
//

import UIKit
import CoreData

class ForgetPasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailaddressTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    let app = UIApplication.shared.delegate as! AppDelegate
    var viewContext: NSManagedObjectContext!
    
    @IBAction func resetBtn(_ sender: UIButton) {
        Components.highlightBorder(target: emailaddressTF, duration: 0.3, Width: 2, Color: .clear)
        Components.highlightBorder(target: phoneTF, duration: 0.3, Width: 2, Color: .clear)

         if (emailaddressTF.text == "" || phoneTF.text == ""){
             if (emailaddressTF.text == ""){
                Components.highlightBorder(target: emailaddressTF, duration: 0.3, Width: 2, Color: .red)
             }
             if (phoneTF.text == ""){
                Components.highlightBorder(target: phoneTF, duration: 0.3, Width: 2, Color: .red)
             }
             
             Components.displayMessage(target: errorLabel ,msg: "Please fill in the required details", duration: 3)
             return
         }
        
        if (!Components.isValidEmail(emailaddressTF.text!)){
            Components.highlightBorder(target: emailaddressTF, duration: 0.3, Width: 2, Color: .red)
            Components.displayMessage(target: errorLabel ,msg: "Invalid email address", duration: 3)
            return
        }
        
        viewContext = app.persistentContainer.viewContext
        do {
            let phoneNo = Int32(phoneTF.text!)
            let allUsers = try viewContext.fetch(Users.fetchRequest())
            
            for user in allUsers as! [Users] {
                if user.emailAddress == emailaddressTF.text && user.phoneNo == phoneNo {
                    performSegue(withIdentifier: "toResetPwd", sender: nil)
                } else {
                    Components.displayMessage(target: errorLabel, msg: "We're unable to retrieve the account with the information provided.", duration: 5)
                }
            }
        } catch {
            print(error)
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
        phoneTF.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "toResetPwd" {
            let target = segue.destination as! ForgetPasswordViewController2
            target.emailaddress = emailaddressTF.text!
        }
    }
}

class ForgetPasswordViewController2: UIViewController {
    
    var emailaddress = String()
    
    let app = UIApplication.shared.delegate as! AppDelegate
    var viewContext: NSManagedObjectContext!
    
    @IBOutlet weak var newPwdTF: UITextField!
    @IBOutlet weak var cfmnewPwdTF: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var resetBtnOutlet: CustomButtons!
    
    @IBAction func resetPwdBtn(_ sender: Any) {
        Components.highlightBorder(target: newPwdTF, duration: 0.3, Width: 2, Color: .clear)
        Components.highlightBorder(target: cfmnewPwdTF, duration: 0.3, Width: 2, Color: .clear)
        
        if (newPwdTF.text == cfmnewPwdTF.text) {
            viewContext = app.persistentContainer.viewContext
            do {
                let allUsers = try viewContext.fetch(Users.fetchRequest())
                for user in allUsers as! [Users] {
                    if user.emailAddress == emailaddress {
                        user.password = newPwdTF.text
                    }
                }
                app.saveContext()
                
                let alert = UIAlertController(title: "Password Reset", message: "Your password has been reset.", preferredStyle: .alert)
                       alert.addAction(UIAlertAction(title: "Proceed to Login", style: .default, handler: {
                           action in self.performSegue(withIdentifier: "toLogin", sender: self)
                       }))
                self.present(alert, animated: true)
                
            } catch {
                print(error)
            }
        } else {
            Components.highlightBorder(target: newPwdTF, duration: 0.3, Width: 2, Color: .red)
            Components.highlightBorder(target: cfmnewPwdTF, duration: 0.3, Width: 2, Color: .red)
            Components.displayMessage(target: errorLabel, msg: "Passwords do not match", duration: 3)
        }
    }
    
    @IBAction func InputChanged(_ sender: UITextField) {
        updateBtnState()
    }
    
    @IBAction func pwdVisibility(_ sender: UIButton) {
        if (newPwdTF.isSecureTextEntry) {
            newPwdTF.isSecureTextEntry = false
            cfmnewPwdTF.isSecureTextEntry = false
            
            sender.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        } else{
            newPwdTF.isSecureTextEntry = true
            cfmnewPwdTF.isSecureTextEntry = true
            
            sender.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        }
    }
    
    func updateBtnState() {
        if (newPwdTF.text != "" && cfmnewPwdTF.text != ""){
            resetBtnOutlet.isEnabled = true
            resetBtnOutlet.backgroundColor = #colorLiteral(red: 0.7725490196, green: 0.431372549, blue: 0.3568627451, alpha: 1)
        } else{
            resetBtnOutlet.isEnabled = false
            resetBtnOutlet.backgroundColor = #colorLiteral(red: 0.8980392157, green: 0.5921568627, blue: 0.5254901961, alpha: 1)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateBtnState()
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
