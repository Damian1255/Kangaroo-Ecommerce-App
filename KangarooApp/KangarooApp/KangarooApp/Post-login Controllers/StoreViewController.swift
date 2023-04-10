//
//  StoreViewController.swift
//  KangarooApp
//
//  Created by Damian on 18/1/22.
//  Copyright © 2022 ITE. All rights reserved.
//

import UIKit
import CoreData
import ViewAnimator

class StoreViewController: UIViewController, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let newArrivalsIdentifier = "newArrivalsCell"
    let categoryIdentifier = "categoryCell"
    let saleIdentifier = "salesCell"
    let discoveryIdentifier = "discoverCell"

    @IBOutlet weak var creditLbl: UILabel!
    @IBOutlet weak var SearchTF: CustomTextField!
    
    @IBOutlet weak var newArrivalsCollectionView: UICollectionView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var saleCollectionView: UICollectionView!
    @IBOutlet weak var discoveryCollectionView: UICollectionView!
    
    let username = UserDefaults.standard.string(forKey: "User")
    
    var newArrivalsproductID = [Int16]()
    var newArrivalsproductName = [String]()
    var newArrivalsproductImage = [String]()
    var newArrivalsDesc = [String]()
    var newArrivalsPrice = [Int]()
    
    var discoveryproductID = [Int16]()
    var discoveryproductName = [String]()
    var discoveryproductImage = [String]()
    var discoveryproductRating = [Double]()
    var discoveryproductPrice = [Double]()
    var discoverysalePrice = [Double]()
    var discoveryIsOnSale = [Int]()

    var saleProductID = [Int16]()
    var saleProductName = [String]()
    var saleProductImage = [String]()
    var saleRating = [Double]()
    var saleNormalPrice = [Double]()
    var salePrice = [Double]()
    
    var productCategory = [String]()
    
    var ID:Int16?
    var Category:String?
    var Display:String?
    var sortkey: String = "productName"
    var ascend: Bool = true
    
    var cellIndex = 0
    var timer:Timer?
       
    let app = UIApplication.shared.delegate as! AppDelegate
    var viewContext: NSManagedObjectContext!
    
    var userInfo = UserDefaults.standard
       
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == newArrivalsCollectionView) {
            return newArrivalsproductID.count
        } else if (collectionView == categoryCollectionView){
            return productCategory.count
        } else if (collectionView == saleCollectionView){
            return saleProductID.count
        } else {
            return discoveryproductID.count
        }
    }
       
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (collectionView == newArrivalsCollectionView) {
            let newArrivalCell = newArrivalsCollectionView.dequeueReusableCell(withReuseIdentifier: newArrivalsIdentifier, for: indexPath) as! newArrivalsCell
            
            newArrivalCell.newArrivalsProductImage.image = UIImage(named: newArrivalsproductImage[indexPath.row])
            newArrivalCell.newArrivalsProductName.text = newArrivalsproductName[indexPath.row]
            newArrivalCell.newDesc.text = newArrivalsDesc[indexPath.row]
            newArrivalCell.newPrice.text = String(newArrivalsPrice[indexPath.row]) + " RC"
               
            return newArrivalCell
        } else if (collectionView == categoryCollectionView){
            let categoryCell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: categoryIdentifier, for: indexPath) as! categoryCell
               
            categoryCell.categoryLabel.text = productCategory[indexPath.row]
               
            return categoryCell
        } else if (collectionView == saleCollectionView){
            let saleCell = saleCollectionView.dequeueReusableCell(withReuseIdentifier: saleIdentifier, for: indexPath) as! salesCell
               
            saleCell.saleProductImage.image = UIImage(named: saleProductImage[indexPath.row])
            saleCell.saleProductName.text = saleProductName[indexPath.row]
            saleCell.saleRating.rating = saleRating[indexPath.row]
            saleCell.saleRating.text = "(\(Int(saleRating[indexPath.row]))) RC" 
            
            let attributedText = NSAttributedString(
                string: String(Int(saleNormalPrice[indexPath.row])) + " RC",
                attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
            )
            saleCell.salePrice.attributedText = attributedText
            
            saleCell.saleSalePrice.text = String(Int(salePrice[indexPath.row])) + " RC"
               
            return saleCell
        } else {
            let discoverCell = discoveryCollectionView.dequeueReusableCell(withReuseIdentifier: discoveryIdentifier, for: indexPath) as! discoveryCell
               
            discoverCell.discoveryImage.image = UIImage(named: discoveryproductImage[indexPath.row])
            discoverCell.discoveryName.text = discoveryproductName[indexPath.row]
            discoverCell.discoveryRating.rating = discoveryproductRating[indexPath.row]
            discoverCell.discoveryRating.text = "(\(Int(discoveryproductRating[indexPath.row])))"
            
            if (discoveryIsOnSale[indexPath.row] == 1) {
                let attributedText = NSAttributedString(
                    string: String(Int(discoveryproductPrice[indexPath.row])) + " RC",
                    attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
                )
                discoverCell.discoveryPrice.attributedText = attributedText
                
                discoverCell.discoverySalePrice.text = String(Int(discoverysalePrice[indexPath.row])) + " RC"
                discoverCell.discoverySalePrice.isHidden = false
            } else {
                discoverCell.discoveryPrice.text = String(Int(discoveryproductPrice[indexPath.row])) + " RC"
                discoverCell.discoverySalePrice.isHidden = true
            }
            
            do {
                let allUser = try viewContext.fetch(Users.fetchRequest())
                for user in allUser as! [Users] {
                    if user.username == username {
                        if ((user.wishlistItems?.contains(Int(discoveryproductID[indexPath.row])))!){
                            discoverCell.wishlistBtn.setBackgroundImage(UIImage(systemName:"heart.fill"), for: .normal)
                        } else {
                            discoverCell.wishlistBtn.setBackgroundImage(UIImage(systemName:"heart"), for: .normal)
                        }
                    }
                }

            } catch {print(error)}
            discoverCell.wishlistBtn.tag = Int(discoveryproductID[indexPath.row])
            discoverCell.wishlistBtn.addTarget(self, action: #selector(self.addToWishlist), for: .touchUpInside)
            
            
            return discoverCell
        }
    }
    
    @IBAction func viewAll(_ sender: UIButton) {
        Display = "Discover"
        performSegue(withIdentifier: "toCollection", sender: nil)
    }
    
    @IBAction func viewSales(_ sender: UIButton) {
        Display = "On Sale"
        performSegue(withIdentifier: "toCollection", sender: nil)
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {}

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (collectionView == newArrivalsCollectionView) {
            ID = newArrivalsproductID[indexPath.row]
            performSegue(withIdentifier: "toProduct", sender: nil)
        } else if (collectionView == categoryCollectionView){
            Category = productCategory[indexPath.row]
            performSegue(withIdentifier: "toCategory", sender: nil)
        } else if (collectionView == saleCollectionView) {
            ID = saleProductID[indexPath.row]
            performSegue(withIdentifier: "toProduct", sender: nil)
        } else {
            ID = discoveryproductID[indexPath.row]
            performSegue(withIdentifier: "toProduct", sender: nil)
        }
    }
    
    @IBAction func searchInput(_ sender: UITextField) {
        if (sender.text != ""){
            performSegue(withIdentifier: "toSearch", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toProduct" {
            let target = segue.destination as! ProductViewController
            target.productID = ID!
        }
        
        if segue.identifier == "toCategory" {
            let target = segue.destination as! CategoryViewController
            target.productCategory = Category!
        }
        
        if segue.identifier == "toSearch" {
            let target = segue.destination as! SearchViewController
            target.query = SearchTF.text!
        }
        if segue.identifier == "toCollection" {
            let target = segue.destination as! CollectionVewController
            target.display = Display!
        }
    }
       
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewContext = app.persistentContainer.viewContext
        
        loadNewArrivals()
        loadCategories()
        loadSales()
        loadDiscovery(sortkey: sortkey, ascend: ascend)
        
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(slideToNext), userInfo: nil, repeats: true)
        
        let products = Product()
        products.deleteAllProducts()
        products.loadProduct()
        
        animate()
        
        newArrivalsCollectionView.backgroundColor = UIColor.clear.withAlphaComponent(0)
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        do {
             let allUsers = try viewContext.fetch(Users.fetchRequest())
            
             for user in allUsers as! [Users] {
                if user.username == username {
                    self.navigationItem.title = "Hello, \(user.firstName!)"
                    creditLbl.text = "You have \(user.credits) RooCredits."
                }
            }
        } catch{
            print(error)
        }
        
        discoveryproductID.removeAll()
        discoveryproductName.removeAll()
        discoveryproductImage.removeAll()
        discoveryproductPrice.removeAll()
        discoverysalePrice.removeAll()
        discoveryproductRating.removeAll()
        discoveryIsOnSale.removeAll()
        
        loadDiscovery(sortkey: sortkey, ascend: ascend)
        discoveryCollectionView.reloadData()
    }
    
    @objc func addToWishlist(_ sender: UIButton) {
        if ((sender.backgroundImage(for: .normal)) == UIImage(systemName: "heart.fill")) {
            sender.setBackgroundImage(UIImage(systemName:"heart"), for: .normal)
            do {
                let allUser = try viewContext.fetch(Users.fetchRequest())
                for user in allUser as! [Users] {
                    if user.username == username {
                        if let index = user.wishlistItems!.firstIndex(of: sender.tag) {
                            user.wishlistItems?.remove(at: index)
                        }
                    }
                }
                app.saveContext()
            } catch {
                print(error)
            }
        } else{
            sender.setBackgroundImage(UIImage(systemName:"heart.fill"), for: .normal)
            do {
                let allUser = try viewContext.fetch(Users.fetchRequest())
                for user in allUser as! [Users] {
                    if user.username == username {
                        user.wishlistItems?.append(sender.tag)
                    }
                }
                app.saveContext()
            } catch {
                print(error)
            }
        }
    }
    
    func loadNewArrivals() {
        do {
            let allProducts = try viewContext.fetch(Products.fetchRequest())
            for product in allProducts as! [Products] {
                if (product.isFeatured == 1){
                    newArrivalsproductID.append(product.id)
                    newArrivalsproductName.append(product.productName!)
                    newArrivalsproductImage.append(product.productImage!)
                    newArrivalsPrice.append(Int(product.productPrice))
                    newArrivalsDesc.append(product.productDesc!)
                }
            }
        }catch{
            print(error)
        }
    }
    
    func loadDiscovery(sortkey: String, ascend: Bool) {
        discoveryproductID.removeAll()
        discoveryproductName.removeAll()
        discoveryproductImage.removeAll()
        
        let fetchRequest: NSFetchRequest<Products> = Products.fetchRequest()
        let sort = NSSortDescriptor(key: sortkey, ascending: ascend)
        
        fetchRequest.sortDescriptors = [sort]
        
        do {
            let allProducts = try viewContext.fetch(fetchRequest)
            for product in allProducts {
                discoveryproductID.append(product.id)
                discoveryproductName.append(product.productName!)
                discoveryproductImage.append(product.productImage!)
                discoveryproductPrice.append(product.productPrice)
                discoverysalePrice.append(product.salePrice)
                discoveryproductRating.append(Double(product.productRating))
                discoveryIsOnSale.append(Int(product.isOnSale))
            }
        }catch{
            print(error)
        }
        discoveryCollectionView.reloadData()
    }
    
    func loadSales() {
        do {
            let allProducts = try viewContext.fetch(Products.fetchRequest())
            for product in allProducts as! [Products] {
                if (product.isOnSale == 1){
                    saleProductID.append(product.id)
                    saleProductName.append(product.productName!)
                    saleProductImage.append(product.productImage!)
                    saleRating.append(Double(product.productRating))
                    saleNormalPrice.append(product.productPrice)
                    salePrice.append(product.salePrice)
                }
            }
        }catch{
            print(error)
        }
    }
    
    func loadCategories() {
        do {
            let allProducts = try viewContext.fetch(Products.fetchRequest())
            for product in allProducts as! [Products] {
                if (!productCategory.contains(product.productCategory!)){
                    productCategory.append(product.productCategory!)
                }
            }
        }catch{
            print(error)
        }
    }
       
    @objc func slideToNext() {
        if (cellIndex < newArrivalsproductID.count-1) {
            cellIndex += 1
        }else{
            cellIndex = 0
        }
           
        newArrivalsCollectionView.scrollToItem(at: IndexPath(item: cellIndex, section: 0), at: .right, animated: true)
    }
    
    let fromAnimation = AnimationType.from(direction: .right, offset: 30.0)
    let zoomAnimation = AnimationType.zoom(scale: 0.2)
    let rotateAnimation = AnimationType.rotate(angle: CGFloat.pi/6)
    
    func animate() {
        categoryCollectionView?.performBatchUpdates({
            UIView.animate(views: self.newArrivalsCollectionView!.orderedVisibleCells,
                animations: [fromAnimation, zoomAnimation, rotateAnimation], completion: {
                })
        }, completion: nil)
        
        categoryCollectionView?.performBatchUpdates({
            UIView.animate(views: self.categoryCollectionView!.orderedVisibleCells,
                animations: [fromAnimation, zoomAnimation, rotateAnimation], completion: {
                })
        }, completion: nil)
        
        saleCollectionView?.performBatchUpdates({
            UIView.animate(views: self.saleCollectionView!.orderedVisibleCells,
                animations: [fromAnimation, zoomAnimation, rotateAnimation], completion: {
                })
        }, completion: nil)
        
        discoveryCollectionView?.performBatchUpdates({
            UIView.animate(views: self.discoveryCollectionView!.orderedVisibleCells,
                animations: [fromAnimation, zoomAnimation, rotateAnimation], completion: {
                })
        }, completion: nil)
    }
}
