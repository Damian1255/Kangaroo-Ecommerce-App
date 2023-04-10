//
//  TopUpViewController.swift
//  KangarooApp
//
//  Created by Damian on 17/2/22.
//  Copyright © 2022 ITE. All rights reserved.
//

import UIKit
import CoreData

class TopUpViewController: UIViewController {
    
    let app = UIApplication.shared.delegate as! AppDelegate
    var viewContext: NSManagedObjectContext!
    var userCredits: Int16 = 0
    var topUpAmount: Int = 0
    
    let username = UserDefaults.standard.string(forKey: "User")
    
    @IBOutlet weak var Credits: UILabel!
    @IBOutlet weak var newCredits: UILabel!
    @IBOutlet weak var CreditSliderValue: UILabel!
    @IBOutlet weak var confirmBtn: CustomButtons!
    
    @IBAction func CreditSlider(_ sender: UISlider) {
        if (sender.value > 0){
            confirmBtn.isHidden
                = false
            CreditSliderValue.text! = "+" + String(Int16(sender.value))  + " RC"
            topUpAmount = Int(sender.value)
            newCredits.text = String(Int(userCredits) + topUpAmount) + " RC"
        } else {
            confirmBtn.isHidden = true
        }
    }
    
    @IBAction func CfmTopUp(_ sender: Any) {
        if (topUpAmount > 0) {
            let alert = UIAlertController(title: "Confirm Top-up", message: "Pay $\(topUpAmount) for \(topUpAmount) RooCredits?", preferredStyle: UIAlertController.Style.alert)
            
            let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {
                UIAlertAction in
                 do {
                    let allUsers = try self.viewContext.fetch(Users.fetchRequest())
                    
                     for user in allUsers as! [Users] {
                        if user.username == self.username {
                            user.credits += Int16(self.topUpAmount)
                        }
                    }
                } catch{
                    print(error)
                }
                
                self.app.saveContext()
                
                self.performSegue(withIdentifier: "toHome", sender: nil)
            }
            alert.addAction(okAction)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            
            self.present(alert, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewContext = app.persistentContainer.viewContext
        
         do {
             let allUsers = try viewContext.fetch(Users.fetchRequest())
            
             for user in allUsers as! [Users] {
                if user.username == username {
                    Credits.text = "You have " + String(user.credits) + " RC"
                    userCredits = user.credits
                }
            }
        } catch{
            print(error)
        }
    }
    
}
