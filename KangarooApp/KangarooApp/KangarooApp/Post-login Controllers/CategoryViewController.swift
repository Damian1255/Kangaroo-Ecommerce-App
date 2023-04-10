//
//  CategoryViewController.swift
//  KangarooApp
//
//  Created by Damian on 12/2/22.
//  Copyright © 2022 ITE. All rights reserved.
//

import UIKit
import CoreData
import ViewAnimator

class CategoryViewController: UIViewController, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let discoveryIdentifier = "categoryCell"
    let username = UserDefaults.standard.string(forKey: "User")
    
    var ID:Int16?
    
    var ProductID = [Int16]()
    var ProductName = [String]()
    var ProductImage = [String]()
    var ProductRating = [Double]()
    var ProductPrice = [Double]()
    var ProductSalePrice = [Double]()
    var ProductIsOnSale = [Int]()
    
    var productCategory:String = ""
    
    var sortkey: String = "productName"
    var ascend: Bool = true
    
    @IBOutlet weak var categoryDisplayCV: UICollectionView!
    @IBOutlet weak var searchTF: UITextField!
    
    let app = UIApplication.shared.delegate as! AppDelegate
    var viewContext: NSManagedObjectContext!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ProductID.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let categoryCell = categoryDisplayCV.dequeueReusableCell(withReuseIdentifier: discoveryIdentifier, for: indexPath) as! displaycategoryCell
        
        categoryCell.displaycategoryImage.image = UIImage(named: ProductImage[indexPath.row])
        categoryCell.displaycategoryName.text = ProductName[indexPath.row]
        categoryCell.displayRating.rating = ProductRating[indexPath.row]
        categoryCell.displayRating.text = "(\(Int(ProductRating[indexPath.row])))"
         
        if (ProductIsOnSale[indexPath.row] == 1) {
            let attributedText = NSAttributedString(
                string: String(Int(ProductPrice[indexPath.row])) + " RC",
                attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
            )
            categoryCell.displayPrice.attributedText = attributedText
             
            categoryCell.displaySalePrice.text = String(Int(ProductSalePrice[indexPath.row])) + " RC"
            categoryCell.displaySalePrice.isHidden = false
        } else {
            categoryCell.displayPrice.text = String(Int(ProductPrice[indexPath.row])) + " RC"
            categoryCell.displaySalePrice.isHidden = true
        }
        
        do {
            let allUser = try viewContext.fetch(Users.fetchRequest())
            for user in allUser as! [Users] {
                if user.username == username {
                    if ((user.wishlistItems?.contains(Int(ProductID[indexPath.row])))!){
                        categoryCell.wishlistBtn.setBackgroundImage(UIImage(systemName:"heart.fill"), for: .normal)
                    } else {
                        categoryCell.wishlistBtn.setBackgroundImage(UIImage(systemName:"heart"), for: .normal)
                    }
                }
            }

        } catch {print(error)}
        categoryCell.wishlistBtn.tag = Int(ProductID[indexPath.row])
        categoryCell.wishlistBtn.addTarget(self, action: #selector(self.addToWishlist), for: .touchUpInside)
        
        return categoryCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        ID = ProductID[indexPath.row]
        performSegue(withIdentifier: "toProduct", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toProduct" {
            let target = segue.destination as! ProductViewController
            target.productID = ID!
        }
    }
    
    @IBAction func Sortby(_ sender: UIButton) {
        if ascend {
      sender.setBackgroundImage(UIImage(systemName:"arrow.down.circle.fill"), for: .normal)
            ascend = false
        }
        else {
            sender.setBackgroundImage(UIImage(systemName:"arrow.up.circle.fill"), for: .normal)
            ascend = true
        }
        
        updateResult()
        animate()
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
    
    @IBAction func SortType(_ sender: UIButton) {
        if (sender.titleLabel?.text == "Name") {
            sortkey = "productPrice"
            sender.setTitle("Price", for: .normal)
        }
        if (sender.titleLabel?.text == "Price") {
            sortkey = "productRating"
            sender.setTitle("Rating", for: .normal)
        }
        if (sender.titleLabel?.text == "Rating") {
            sortkey = "productName"
            sender.setTitle("Name", for: .normal)
        }
        
        updateResult()
        animate()
    }
    
    @IBAction func searchQuery(_ sender: UITextField) {
        updateResult()
        animate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = productCategory
        self.navigationController?.isNavigationBarHidden = false
        
        viewContext = app.persistentContainer.viewContext
        
        getCategory(category: productCategory, sortkey: sortkey, ascend: ascend)
        //animate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateResult()
    }
    
    func updateResult() {
        ProductID.removeAll()
        ProductName.removeAll()
        ProductImage.removeAll()
        ProductRating.removeAll()
        ProductPrice.removeAll()
        ProductSalePrice.removeAll()
        ProductIsOnSale.removeAll()
        
        getCategory(category: productCategory, sortkey: sortkey, ascend: ascend)
        categoryDisplayCV.reloadData()
    }
    
    func getCategory(category: String, sortkey: String, ascend: Bool){
        let fetchRequest: NSFetchRequest<Products> = Products.fetchRequest()
        let sort = NSSortDescriptor(key: sortkey, ascending: ascend)
        
        fetchRequest.sortDescriptors = [sort]
        
        if (searchTF.text != ""){
            let predicate = NSPredicate(format: "productName CONTAINS[cd] %@", searchTF.text!)
            fetchRequest.predicate = predicate
        }
        
        do {
            let allProduct = try viewContext.fetch(fetchRequest)
            for product in allProduct {
                if (product.productCategory == category) {
                    ProductID.append(product.id)
                    ProductName.append(product.productName!)
                    ProductImage.append(product.productImage!)
                    ProductRating.append(Double(product.productRating))
                    ProductPrice.append(product.productPrice)
                    ProductSalePrice.append(product.salePrice)
                    ProductIsOnSale.append(Int(product.isOnSale))
                }
            }
        } catch {
            print(error)
        }
    }
    
    let fromAnimation = AnimationType.from(direction: .right, offset: 30.0)
    let zoomAnimation = AnimationType.zoom(scale: 0.2)
    let rotateAnimation = AnimationType.rotate(angle: CGFloat.pi/6)
    
    func animate() {
        categoryDisplayCV?.performBatchUpdates({
            UIView.animate(views: self.categoryDisplayCV!.orderedVisibleCells,
                animations: [fromAnimation, zoomAnimation, rotateAnimation], completion: {
                })
        }, completion: nil)
    }
}
