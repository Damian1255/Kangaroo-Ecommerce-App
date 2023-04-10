//
//  ProductViewController.swift
//  CarouselTest2
//
//  Created by Damian on 5/2/22.
//  Copyright © 2022 Damian. All rights reserved.
//

import UIKit
import CoreData
import Foundation


class ProductViewController: UIViewController {
    
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var productCategory: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productRating: CosmosView!
    @IBOutlet weak var productDesc: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
    @IBOutlet weak var colorPicker: WMSegment!
    @IBOutlet weak var sizePicker: WMSegment!
    @IBOutlet weak var wishlistBtn: UIBarButtonItem!
    
    var productID:Int16 = 0
    var ProductName:String = ""
    var ProductCategory:String = ""
    var ProductPrice:Double = 0.0
    var ProductImage:String = ""
    var ProductDesc:String = ""
    var ProductRating:Double = 0
    var quantity:Int = 1
    
    var colors = [String]()
    var sizes = [String]()
    
    let app = UIApplication.shared.delegate as! AppDelegate
    var viewContext: NSManagedObjectContext!
    
    let username = UserDefaults.standard.string(forKey: "User")
    
    @IBAction func quantityChanged(_ sender: SwiftyStepper) {
        quantity = Int(sender.value)
    }
    
    @IBAction func addToWishlist(_ sender: UIBarButtonItem) {
        if ((sender.image) == UIImage(systemName: "heart.fill")) {
            sender.image = UIImage(systemName: "heart")
            removeFromWishlist()
        } else{
            sender.image = UIImage(systemName: "heart.fill")
            addToWishlist()
        }
    }
    
    @IBAction func addToCart(_ sender: UIButton) {
        var itemExists = true
        do {
            let allUser = try viewContext.fetch(Users.fetchRequest())
            for user in allUser as! [Users] {
                if user.username == username {
                    for index in 0..<user.cartItems!.count {
                        if (user.cartItems![index].count > 0 && user.cartItems![index][0] as! Int16 == Int(productID) && user.cartItems![index][3] as! String == colors[colorPicker!.selectedSegmentIndex] && user.cartItems![index][4] as! String == sizes[sizePicker!.selectedSegmentIndex]){
                            var q = user.cartItems![index][1] as! Int
                            q += quantity
                            user.cartItems![index][1] = q
                            addToCartAlert()
                            return
                        } else {
                            itemExists = false
                        }
                    }
                    if (itemExists == false) {
                        user.cartItems?.append([Int(productID), quantity, 0, colors[colorPicker!.selectedSegmentIndex], sizes[sizePicker!.selectedSegmentIndex]])
                        addToCartAlert()
                    }
                }
            }
            app.saveContext()
            
        } catch { print(error) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        
        viewContext = app.persistentContainer.viewContext
        getProduct(id: productID)
        
        productLabel.text = ProductName
        productDesc.text = ProductDesc
        productImage.image = UIImage(named: ProductImage)
        productRating.rating = ProductRating
        productRating.text = "(\(String(Int(ProductRating))))"
        productCategory.text = ProductCategory
        productPrice.text = String(Int(ProductPrice)) + " RC"
        
        do {
            let allUser = try viewContext.fetch(Users.fetchRequest())
            for user in allUser as! [Users] {
                if user.username == username {
                    if ((user.wishlistItems?.contains(Int(productID)))!){
                        wishlistBtn.image = UIImage(systemName: "heart.fill")
                    }
                }
            }

        } catch {
            print(error)
        }
        
    }
    
    func getProduct(id: Int16){
        do {
            let allProduct = try viewContext.fetch(Products.fetchRequest())
            for product in allProduct as! [Products] {
                if product.id == productID {
                    ProductName = product.productName!
                    ProductImage = product.productImage!
                    ProductRating = Double(product.productRating)
                    ProductDesc = product.productDesc!
                    ProductCategory = product.productCategory!
                    
                    if (product.isOnSale == 1) {
                        ProductPrice = product.salePrice
                    } else {
                        ProductPrice = product.productPrice
                    }
                    
                    colorPicker.buttonTitles = product.productColour!
                    sizePicker.buttonTitles = product.productSize!
                    
                    colors = product.productColour!.components(separatedBy: ",")
                    sizes = product.productSize!.components(separatedBy: ",")
                }
            }
        } catch {
            print(error)
        }
    }
    
    func addToWishlist() {
        do {
            let allUser = try viewContext.fetch(Users.fetchRequest())
            for user in allUser as! [Users] {
                if user.username == username {
                    user.wishlistItems?.append(Int(productID))
                }
            }
            app.saveContext()
        } catch {
            print(error)
        }
    }
    
    func removeFromWishlist() {
        do {
            let allUser = try viewContext.fetch(Users.fetchRequest())
            for user in allUser as! [Users] {
                if user.username == username {
                    if let index = user.wishlistItems!.firstIndex(of: Int(productID)) {
                        user.wishlistItems?.remove(at: index)
                    }
                }
            }
            app.saveContext()
        } catch {
            print(error)
        }
    }
    
    func addToCartAlert() {
        let alert = UIAlertController(title: "Item Added", message: "Item has been added to your cart", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}
