//
//  ChangePasswordViewController.swift
//  KangarooApp
//
//  Created by Damian on 26/2/22.
//  Copyright © 2022 ITE. All rights reserved.
//

import UIKit
import CoreData

class ChangePasswordViewController: UIViewController {
    
    let app = UIApplication.shared.delegate as! AppDelegate
    var viewContext: NSManagedObjectContext!
    let username = UserDefaults.standard.string(forKey: "User")!
    
    @IBOutlet weak var currrentPw: UITextField!
    @IBOutlet weak var newPw: UITextField!
    @IBOutlet weak var confirmPw: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBAction func pwdVisibility(_ sender: UIButton) {
        if (newPw.isSecureTextEntry) {
            newPw.isSecureTextEntry = false
            confirmPw.isSecureTextEntry = false
            sender.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        } else{
            newPw.isSecureTextEntry = true
            confirmPw.isSecureTextEntry = true
            sender.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        }
    }
    
    @IBAction func SaveBtn(_ sender: UIButton) {
        Components.highlightBorder(target: currrentPw, duration: 0.3, Width: 2, Color: .clear)
        Components.highlightBorder(target: newPw, duration: 0.3, Width: 2, Color: .clear)
        Components.highlightBorder(target: confirmPw, duration: 0.3, Width: 2, Color: .clear)
        
        if (currrentPw.text == "" || newPw.text == "" || confirmPw.text == ""){
            if (currrentPw.text == ""){
                Components.highlightBorder(target: currrentPw, duration: 0.3, Width: 2, Color: .red)
            }
            if (newPw.text == ""){
                Components.highlightBorder(target: newPw, duration: 0.3, Width: 2, Color: .red)
            }
            if (confirmPw.text == ""){
                Components.highlightBorder(target: confirmPw, duration: 0.3, Width: 2, Color: .red)
            }
                       
            Components.displayMessage(target: errorLabel, msg: "Please fill in the required fields", duration: 3)
        }
        else {
            if (newPw.text! == confirmPw.text!) {
                saveData()
            }
        }
    }
    
    func saveData() {
        do {
            let all = try viewContext.fetch(Users.fetchRequest())
            for user in all as! [Users] {
                if (user.username == username){
                    if (user.password == currrentPw.text!){
                        user.password = newPw.text
                        app.saveContext()
                        
                        let alert = UIAlertController(title: "Password Updated", message: "Your password has been updated", preferredStyle: UIAlertController.Style.alert)

                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (actionSheetController) -> Void in
                            self.performSegue(withIdentifier: "backToAccount", sender: nil)
                        }))
                        
                        present(alert, animated: true, completion: nil)
                        performSegue(withIdentifier: "backToAccount", sender: nil)
                    } else {
                        Components.displayMessage(target: errorLabel, msg: "Current Password is incorrect", duration: 3)
                    }
                }
            }
        } catch {}
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
