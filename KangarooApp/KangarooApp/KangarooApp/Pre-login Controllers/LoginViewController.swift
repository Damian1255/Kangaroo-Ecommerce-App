//
//  LoginViewController.swift
//  KangarooApp
//
//  Created by Damian on 17/1/22.
//  Copyright © 2022 ITE. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: UIViewController, CAAnimationDelegate {

    @IBOutlet var usernameTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {}
    
    let app = UIApplication.shared.delegate as! AppDelegate
    var viewContext: NSManagedObjectContext!
    
    var userInfo = UserDefaults.standard
    
    @IBAction func pwdVisibility(_ sender: UIButton) {
        if (passwordTF.isSecureTextEntry) {
            passwordTF.isSecureTextEntry = false
            sender.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        } else{
            passwordTF.isSecureTextEntry = true
            sender.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func hopinBtn(_ sender: UIButton) {
        Components.highlightBorder(target: usernameTF, duration: 0.2, Width: 0, Color: .clear)
        Components.highlightBorder(target: passwordTF, duration: 0.2, Width: 0, Color: .clear)
        
        if (usernameTF.text == "" || passwordTF.text == ""){
            if (usernameTF.text == ""){
                Components.highlightBorder(target: usernameTF, duration: 0.2, Width: 2, Color: .red)
            }
            
            if (passwordTF.text == ""){
                Components.highlightBorder(target: passwordTF, duration: 0.2, Width: 2, Color: .red)
            }
            
            Components.displayMessage(target: errorLabel ,msg: "Please enter login details", duration: 3)
            return
        }
        
        viewContext = app.persistentContainer.viewContext
        Authenticate()
    }
    
    func Authenticate(){
        do {
            let allUsers = try viewContext.fetch(Users.fetchRequest())
            for user in allUsers as! [Users] {
                if user.username == usernameTF.text && user.password == passwordTF.text{
                    userInfo.set(user.username, forKey: "User")
                    userInfo.set(true, forKey: "Loggedin")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
                       
                       (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
                } else{
                    Components.displayMessage(target: errorLabel ,msg: "Incorrect login details", duration: 3)
                }
            }
        } catch {
            print(error)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
}
