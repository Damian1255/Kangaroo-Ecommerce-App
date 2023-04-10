//
//  CheckoutViewController.swift
//  KangarooApp
//
//  Created by Damian on 21/2/22.
//  Copyright © 2022 ITE. All rights reserved.
//

import UIKit
import CoreData

class CheckoutViewController: UIViewController {
    
    @IBOutlet weak var summarryLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var showMapbtn: UIButton!
    @IBOutlet weak var deliveryLbl: UILabel!
    @IBOutlet weak var checkoutBtnOutlet: UIButton!
    @IBOutlet weak var Shakelbl: UILabel!
    @IBOutlet weak var voucherImage: UIImageView!
    @IBOutlet weak var discountLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var FinalPriceLbl: UILabel!
    @IBOutlet weak var Finallbl: UILabel!
    
    let username = UserDefaults.standard.string(forKey: "User")
    
    let app = UIApplication.shared.delegate as! AppDelegate
    var viewContext: NSManagedObjectContext!
    	
    var UserCart = [[Any]]()
    var CartIndex = [Int]()
    var discounts: Int = 0
    var FinalPrice: Int = 0
    
    var TotalPrice: Double = 0.0
    var weather: String = ""
    var Discount: Int = 0
    var key = "dc7d279adafff794a8f7baadb7a7af35"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getWeather()
        
        viewContext = app.persistentContainer.viewContext
        for item in UserCart {
            if (item.count > 0 && item[2] as! Int == 1) {
                let fetchRequest: NSFetchRequest<Products> = Products.fetchRequest()
                let predicate = NSPredicate(format: "id like '" + String(item[0] as! Int) + "'")
                fetchRequest.predicate = predicate
                
                do {
                    let all = try viewContext.fetch(fetchRequest)
                    for product in all {
                        summarryLbl.text! += "\(product.productName!) - x\(item[1])\n\n"
                        if (product.isOnSale == 1){
                            TotalPrice += product.salePrice * Double(item[1] as! Int)
                        } else {
                            TotalPrice += product.productPrice * Double(item[1] as! Int)
                        }
                    }
                } catch {print(error)}
            }
        }
        calculatePrice()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        do {
            let all = try viewContext.fetch(Users.fetchRequest())
            for user in all as! [Users] {
                if (user.username == username){
                    discounts = Int(user.userDiscounts)
                    Shakelbl.text = "Shake for discount - \(discounts) left"
                    addressLbl.text = user.address
                }
            }
        } catch {}
    }
    
    @IBAction func deliveryType(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            showMapbtn.isHidden = false
            deliveryLbl.isHidden = true
        case 1:
            showMapbtn.isHidden = true
            deliveryLbl.isHidden = false
                
            if (weather == "rain" || weather == "shower rain" || weather == "thunderstorm"){
                deliveryLbl.text = "Next Day Delivery"
            } else {
                deliveryLbl.text = "Same Day Delivery"
            }
        default:
            break
        }
    }
    
    @IBAction func Orderbtn(_ sender: UIButton) {
        do {
             let allUsers = try viewContext.fetch(Users.fetchRequest())
            
             for user in allUsers as! [Users] {
                if (user.username == username) {
                    if (user.credits >= Int16(FinalPrice)) {
                        user.credits -= Int16(FinalPrice)
                        
                        for index in user.cartItems! {
                            if (index.count > 0 && index[2] as! Int == 1){
                                var temp = [Any]()
                                temp = index
                                
                                let date = Date()
                                let df = DateFormatter()
                                df.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                let dateString = df.string(from: date)
                                
                                temp.append(dateString)
                                user.orderHistory?.append(temp)
                            }
                        }
                        
                        var offset = 0
                        for i in CartIndex {
                            user.cartItems?.remove(at: i - offset)
                            offset += 1
                        }
                        
                        performSegue(withIdentifier: "toConfirm", sender: nil)
                    } else {
                        let alert = UIAlertController(title: "Insufficient Credits", message: "", preferredStyle: UIAlertController.Style.alert)

                        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                        
                        present(alert, animated: true, completion: nil)
                    }
                }
            }
            app.saveContext()
        } catch{
            print(error)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toConfirm" {
            let target = segue.destination as! ConfirmViewController
            target.price = FinalPrice
        }
    }
    
    func calculatePrice() {
        priceLbl.text = String(Int(TotalPrice)) + " RC"
        FinalPrice = Int(Double(TotalPrice / 100) * Double(100-Discount))
        FinalPriceLbl.text = String(FinalPrice) + " RC"
        
        checkoutBtnOutlet.setTitle("Pay " + String(Int(Double(TotalPrice / 100) * Double(100-Discount))) + " RC", for: .normal
        )
    }
    
    struct Weather: Codable {
        let coord: coordType
        struct coordType: Codable {
            let lon: Double?
            let lat: Double?
        }
        
        let weather: [resultsArray]
        struct resultsArray: Codable {
            let id: Int?
            let main: String?
            let description: String?
            let icon: String?
        }
        
        let base: String?
        let main: mainType
        struct mainType: Codable {
            let temp: Double?
            let pressure: Int?
            let humidity: Int?
            let temp_min: Double?
            let temp_max: Double?
        }
        
         let visibility: Int?
         let wind: windType
         struct windType: Codable {
            let speed: Double?
            let deg: Int?
         }
        
        let timezone: Int?
        let id: Int?
        let name: String?
        let cod: Int?
    }
    
    private func createLayer() {
        let layer = CAEmitterLayer()
        layer.emitterPosition = CGPoint(x: view.center.x,
                                        y: -100)
        
        let images: [UIImage] = [
            UIImage(named: "tea-plant-green-leaf")!,
            UIImage(named: "image")!,
            UIImage(named: "acorn")!
        ]
        
        let cells: [CAEmitterCell] = images.compactMap {
            let cell = CAEmitterCell()
            cell.scale = 0.1
            cell.emissionRange = .pi * 2
            cell.lifetime = 20
            cell.birthRate = 20
            cell.velocity = 150

            cell.contents = $0.cgImage
            
            return cell
        }
        
        layer.emitterCells = cells
        
        view.layer.addSublayer(layer)
    }
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if (motion == .motionShake && discounts > 0) {
            generateDiscount()
            discounts -= 1
            
            do {
                let all = try viewContext.fetch(Users.fetchRequest())
                for user in all as! [Users] {
                    if (user.username == username){
                        user.userDiscounts = Int16(discounts)
                    }
                }
                app.saveContext()
            } catch {}
            
        } else {
            let alert = UIAlertController(title: "Discount unavailable", message: "Sorry, You have ran out of discount coupons.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            present(alert, animated: true)
        }
    }
    
    func getWeather() {
        guard let url = URL(string:"https://api.openweathermap.org/data/2.5/weather?q=Singapore,sg&appid=" + key)
            else {
                return
            }
            
        let task = URLSession.shared.dataTask(with:url) {
            (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return
            }
            do {
                let decoder = JSONDecoder()
                let model = try decoder.decode(Weather.self, from: dataResponse)
                
                DispatchQueue.main.async{
                    self.weather = model.weather[0].description!
                    print(model.weather[0].description!)
                }
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
    
    func generateDiscount() {
        //createLayer()
        
        Shakelbl.isHidden = true
        voucherImage.isHidden = false
        discountLbl.isHidden = false
        
        let randomDouble = Int.random(in: 0...20)
        
        Discount = randomDouble
        discountLbl.text = "\(Discount) %"
        Finallbl.text = "Total -\(Discount)%"
        
        let alert = UIAlertController(title: "Congratulations", message: "You have been given a \(self.Discount)% discount!", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true)
        calculatePrice()
        
    }
}
