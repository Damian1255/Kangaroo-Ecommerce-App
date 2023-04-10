//
//  AccountViewController.swift
//  KangarooApp
//
//  Created by Damian on 5/2/22.
//  Copyright © 2022 ITE. All rights reserved.
//

import UIKit
import CoreData

class AccountViewController: UIViewController {
    
    @IBOutlet weak var userImage: UIButton!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var creditsAvail: UILabel!
    
    @IBOutlet weak var orderHistoy: CustomCardView!
    @IBOutlet weak var EditInfo: CustomCardView!
    @IBOutlet weak var ChangePassword: CustomCardView!
    
    var userInfo = UserDefaults.standard
    
    let app = UIApplication.shared.delegate as! AppDelegate
    var viewContext: NSManagedObjectContext!
    
    @IBAction func LogoutBtn(_ sender: UIButton) {
        userInfo.set(nil, forKey: "User")
        userInfo.set(false, forKey: "Loggedin")

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginNavController = storyboard.instantiateViewController(identifier: "LoginNavigationController")

        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let OrdertapGesture = UITapGestureRecognizer(target: self, action: #selector(orderHistoryTapped(sender:)))
        orderHistoy.addGestureRecognizer(OrdertapGesture)
        
        let EdittapGesture = UITapGestureRecognizer(target: self, action: #selector(editInfoTapped(sender:)))
        EditInfo.addGestureRecognizer(EdittapGesture)
        
        let PasswodtapGesture = UITapGestureRecognizer(target: self, action: #selector(changePasswordTapped(sender:)))
        ChangePassword.addGestureRecognizer(PasswodtapGesture)
    }
    
    @objc func orderHistoryTapped(sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "toHistory", sender: nil)
    }
    
    
    @objc func editInfoTapped(sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "toEdit", sender: nil)
    }
    
    @objc func changePasswordTapped(sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "toPwd", sender: nil)
    }
    
    @IBAction func backtoAccountViewController(segue: UIStoryboardSegue) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewContext = app.persistentContainer.viewContext
        
        let username = userInfo.string(forKey: "User")
        do {
            let allUsers = try viewContext.fetch(Users.fetchRequest())
            for user in allUsers as! [Users] {
                if user.username == username {
                    userName.text = String(user.firstName!)
                    creditsAvail.text = String(user.credits) + " RC Available"
                    userImage.setBackgroundImage(UIImage(data: user.userImage!), for: .normal)
                }
            }
        } catch{
            print(error)
        }
    }
}
