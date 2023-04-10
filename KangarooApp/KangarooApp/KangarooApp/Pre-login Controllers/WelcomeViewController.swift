//
//  ViewController.swift
//  KangarooApp
//
//  Created by Damian on 16/1/22.
//  Copyright © 2022 ITE. All rights reserved.
//

import UIKit
import CoreData

class WelcomeViewController: UIViewController {

    let app = UIApplication.shared.delegate as! AppDelegate
    var viewContext: NSManagedObjectContext!
    
    var userInfo = UserDefaults.standard
    
    @IBAction func unwindToMain(segue: UIStoryboardSegue) {}
    
    func deleteAllUserData() {
        let batch = NSBatchDeleteRequest(fetchRequest: Users.fetchRequest())

        do {
            try app.persistentContainer.persistentStoreCoordinator.execute(batch, with: viewContext)
        }
        catch{
            print(error)
        }
    }
    
    @IBAction func Logout(segue: UIStoryboardSegue) {
        userInfo.set(nil, forKey: "User")
        userInfo.set(false, forKey: "Loggedin")
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func queryAllUserData() {
        do {
            let allUsers = try viewContext.fetch(Users.fetchRequest())

            for user in allUsers as! [Users] {
                print("\(user.username ?? ""), \(user.firstName ?? ""), \(user.credits)")
            }		
        }
        catch{
            print(error)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewContext = app.persistentContainer.viewContext
        //deleteAllUserData()
        queryAllUserData()
        
        let products = Product()
        products.deleteAllProducts()
        products.loadProduct()
        //products.queryAllProducts()
    }
}

