//
//  WishlistViewController.swift
//  KangarooApp
//
//  Created by Damian on 14/2/22.
//  Copyright © 2022 ITE. All rights reserved.
//

import UIKit
import CoreData
import Foundation
import ViewAnimator

class CartViewController: UIViewController, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    let Identifier = "cartCell"

    var ID:Int16?
    let username = UserDefaults.standard.string(forKey: "User")
    var productCategory:String = ""
    var totalPrice: Double = 0.0
    var selectedCount: Int = 0
    
    var UserCart = [[Any]]()
    var cartIndex = [Int]()
    
    var ProductID = [Int16]()
    var ProductName = [String]()
    var ProductImage = [String]()
    var ProductQuantity = [Int]()
    var ProductPrice = [Double]()
    var ProductSelected = [Int]()
    var ProductColor = [String]()
    var ProductSize = [String]()
    
    @IBOutlet weak var cartCollectionView: UICollectionView!
    @IBOutlet weak var emptyLbl: UILabel!
    @IBOutlet weak var totalPriceLbl: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var checkoutBtn: UIButton!
    
    let app = UIApplication.shared.delegate as! AppDelegate
    var viewContext: NSManagedObjectContext!

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ProductID.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cartCell = cartCollectionView.dequeueReusableCell(withReuseIdentifier: Identifier, for: indexPath) as! cartCell
        
        cartCell.cartImage.image = UIImage(named: ProductImage[indexPath.row])
        cartCell.cartName.text = ProductName[indexPath.row]
        cartCell.cartQuantity.text = String(ProductQuantity[indexPath.row])
        cartCell.cartPrice.text = String(Int(ProductPrice[indexPath.row] * Double(ProductQuantity[indexPath.row]))) + " RC"
        
        if (ProductColor[indexPath.row] != "-" || ProductSize[indexPath.row] != "-"){
            cartCell.variantLbl.text = String(ProductColor[indexPath.row]) + ", " + String(ProductSize[indexPath.row])
        } else {
            cartCell.variantLbl.text = "-"
        }
        
        cartCell.quantityStepper.tag = Int(ProductID[indexPath.row])
        cartCell.quantityStepper.restorationIdentifier = ProductColor[indexPath.row] + "," + ProductSize[indexPath.row]
        cartCell.quantityStepper.value = Double(ProductQuantity[indexPath.row])
        cartCell.quantityStepper.addTarget(self, action: #selector(self.updateQuantity), for: .touchUpInside)
        
        cartCell.cartRemoveBtn.tag = Int(ProductID[indexPath.row])
        cartCell.cartRemoveBtn.restorationIdentifier = ProductColor[indexPath.row] + "," + ProductSize[indexPath.row]
        cartCell.cartRemoveBtn.addTarget(self, action: #selector(self.removeItem), for: .touchUpInside)
        
        cartCell.cartSelector.tag = Int(ProductID[indexPath.row])
        cartCell.cartSelector.restorationIdentifier = ProductColor[indexPath.row] + "," + ProductSize[indexPath.row]
        cartCell.cartSelector.addTarget(self, action: #selector(self.selectItem), for: .touchUpInside)
        
        if (ProductSelected[indexPath.row] == 1) {
            cartCell.cartSelector.setImage(UIImage(systemName: "checkmark"), for: .normal)
            calculatePrice()
        } else {
            cartCell.cartSelector.setImage(UIImage(systemName: ""), for: .normal)
            calculatePrice()
        }
        checkoutBtn.setTitle("Checkout \(selectedCount) items", for: .normal)
           
        return cartCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        ID = ProductID[indexPath.row]
        performSegue(withIdentifier: "toProduct", sender: nil)
    }
    
    func calculatePrice() {
        totalPrice = 0.0
        selectedCount = 0
        cartIndex.removeAll()
    
        for index in 0..<ProductSelected.count{
            if (ProductSelected[index] == 1){
                totalPrice += Double(ProductPrice[index] * Double(ProductQuantity[index]))
                cartIndex.append(index + 1)
                selectedCount += 1
            }
        }
        totalPriceLbl.text = String(Int(totalPrice)) + " RC"
        
        if (selectedCount == 0) {
            checkoutBtn.isEnabled = false
        } else {
            checkoutBtn.isEnabled = true
        }
    }
    
    @objc func removeItem(_ sender: UIButton) {
        let attr = sender.restorationIdentifier?.components(separatedBy: ",")
        for index in 0...UserCart.count-1 {
            if (UserCart[index].count > 0 && UserCart[index][0] as! Int == sender.tag && UserCart[index][3] as! String == attr![0] && UserCart[index][4] as! String == attr![1]){
                
                let alert = UIAlertController(title: "Remove Item?", message: "Remove this item from your cart?", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                    self.UserCart.remove(at: index)
                    self.updateCart(username: self.username!)
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc func updateQuantity(_ sender: UIStepper) {
        let attr = sender.restorationIdentifier?.components(separatedBy: ",")
        for index in 0...UserCart.count-1 {
            if (UserCart[index].count > 0 && UserCart[index][0] as! Int == sender.tag && UserCart[index][3] as! String == attr![0] && UserCart[index][4] as! String == attr![1]){
                UserCart[index][1] = Int(sender.value)
            }
        }
        updateCart(username: username!)
    }
    
    @objc func selectItem(_ sender: UIButton) {
        let attr = sender.restorationIdentifier?.components(separatedBy: ",")
        for index in 0...UserCart.count-1 {
            if (UserCart[index].count > 0 && UserCart[index][0] as! Int == sender.tag && UserCart[index][3] as! String == attr![0] && UserCart[index][4] as! String == attr![1]){
                if (sender.currentImage == UIImage(systemName: "checkmark")) {
                    UserCart[index][2] = 0
                    sender.setImage(UIImage(systemName: ""), for: .normal)
                } else {
                    UserCart[index][2] = 1
                    sender.setImage(UIImage(systemName: "checkmark"), for: .normal)
                }
            }
        }
        updateCart(username: username!)
    }
    
    @IBAction func SelectAll(_ sender: UIButton) {
        for index in 0...UserCart.count-1 {
            if (UserCart[index].count > 0){
                UserCart[index][2] = 1
            }
        }
        updateCart(username: username!)
        sender.setImage(UIImage(systemName: "checkmark"), for: .normal)
    }
    
    @IBAction func CheckoutBtn(_ sender: UIButton) {
        performSegue(withIdentifier: "toCheckout", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toProduct" {
            let target = segue.destination as! ProductViewController
            target.productID = ID!
        }
        
        if segue.identifier == "toCheckout" {
            let target = segue.destination as! CheckoutViewController
            target.UserCart = UserCart
            target.CartIndex = cartIndex
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        resetValues()
        viewContext = app.persistentContainer.viewContext
        getCartItems(username: username!)
    
        if (ProductID.count == 0){
            emptyLbl.isHidden = false
            cartCollectionView.isHidden = true
        } else {
            emptyLbl.isHidden = true
            cartCollectionView.isHidden = false
            
            cartCollectionView.reloadData()
        }
        
        subLabel.text = "You have \(ProductID.count) items in your Cart."
        animate()
    }

    @IBAction func unwindToCart(segue: UIStoryboardSegue) {self.navigationController?.isNavigationBarHidden = false}
    
    func updateCart(username: String) {
        do {
            let all = try viewContext.fetch(Users.fetchRequest())
            for user in all as! [Users] {
                if (user.username == username){
                    user.cartItems = UserCart
                }
            }
            app.saveContext()
            
            resetValues()
            getCartItems(username: username)
            
            if (ProductID.count == 0){
                emptyLbl.isHidden = false
                cartCollectionView.isHidden = true
            } else {
                emptyLbl.isHidden = true
                cartCollectionView.isHidden = false
                
                cartCollectionView.reloadData()
            }
         } catch {print(error)}
        subLabel.text = "You have \(ProductID.count) items in your Cart"
        checkoutBtn.setTitle("Checkout \(selectedCount) items", for: .normal)
    }
    
    func getCartItems(username: String) {
        do {
            let all = try viewContext.fetch(Users.fetchRequest())
            for user in all as! [Users] {
                if (user.username == username){
                    UserCart = user.cartItems!
                    print(UserCart)
                }
            }
         } catch {print(error)}

        for item in UserCart {
            if (item.count > 0) {
                let fetchRequest: NSFetchRequest<Products> = Products.fetchRequest()
                let predicate = NSPredicate(format: "id like '" + String(item[0] as! Int) + "'")
                fetchRequest.predicate = predicate
                
                do {
                    let all = try viewContext.fetch(fetchRequest)
                    for product in all {
                        ProductID.append(product.id)
                        ProductName.append(product.productName!)
                        ProductImage.append(product.productImage!)
                        if (product.isOnSale == 1) {
                            ProductPrice.append(product.salePrice)
                        } else {
                            ProductPrice.append(product.productPrice)
                        }
                    }
                } catch {print(error)}
                ProductQuantity.append(item[1] as! Int)
                ProductSelected.append(item[2] as! Int)
                ProductColor.append(item[3] as! String)
                ProductSize.append(item[4] as! String)
            }
        }
        print("Cart loaded")
    }
    
    func resetValues() {
        selectedCount = 0
        totalPrice = 0
        totalPriceLbl.text = String(Int(totalPrice)) + " RC"
        
        ProductID.removeAll()
        ProductName.removeAll()
        ProductImage.removeAll()
        ProductQuantity.removeAll()
        ProductPrice.removeAll()
        ProductSelected.removeAll()
        ProductSize.removeAll()
        ProductColor.removeAll()
    }
    
    let fromAnimation = AnimationType.from(direction: .right, offset: 30.0)
    let zoomAnimation = AnimationType.zoom(scale: 0.2)
    let rotateAnimation = AnimationType.rotate(angle: CGFloat.pi/6)
    
    func animate() {
        cartCollectionView?.performBatchUpdates({
            UIView.animate(views: self.cartCollectionView!.orderedVisibleCells,
                animations: [fromAnimation, zoomAnimation], completion: {
                })
        }, completion: nil)
    }
}
