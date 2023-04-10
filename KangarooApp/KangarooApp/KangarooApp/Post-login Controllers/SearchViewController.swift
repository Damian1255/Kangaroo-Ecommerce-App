//
//  SearchViewController.swift
//  KangarooApp
//
//  Created by Damian on 19/2/22.
//  Copyright © 2022 ITE. All rights reserved.
//

import UIKit
import CoreData
import ViewAnimator

class SearchViewController: UIViewController, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let Identifier = "searchCell"
    let username = UserDefaults.standard.string(forKey: "User")
    
    var ID:Int16?
    
    var ProductID = [Int16]()
    var ProductName = [String]()
    var ProductImage = [String]()
    var ProductRating = [Double]()
    var ProductPrice = [Double]()
    var ProductSalePrice = [Double]()
    var ProductIsOnSale = [Int]()

    var query: String = ""
    
    var sortkey: String = "productName"
    var ascend: Bool = true
    
    @IBOutlet weak var searchCollectionView: UICollectionView!
    @IBOutlet weak var searchTF: CustomTextField!
    
    let app = UIApplication.shared.delegate as! AppDelegate
    var viewContext: NSManagedObjectContext!

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ProductID.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let searchCell = searchCollectionView.dequeueReusableCell(withReuseIdentifier: Identifier, for: indexPath) as! searchCell
        
        searchCell.searchImage.image = UIImage(named: ProductImage[indexPath.row])
        searchCell.searchName.text = ProductName[indexPath.row]
        searchCell.searchRating.rating = ProductRating[indexPath.row]
        searchCell.searchRating.text = "(\(Int(ProductRating[indexPath.row])))"
            
        if (ProductIsOnSale[indexPath.row] == 1) {
            let attributedText = NSAttributedString(
                string: String(Int(ProductPrice[indexPath.row])) + " RC",
                attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
            )
            searchCell.searchPrice.attributedText = attributedText
                
            searchCell.searchSalePrice.text = String(Int(ProductSalePrice[indexPath.row])) + " RC"
            searchCell.searchSalePrice.isHidden = false
        } else {
            searchCell.searchPrice.text = String(Int(ProductPrice[indexPath.row])) + " RC"
                searchCell.searchSalePrice.isHidden = true
        }
        
        do {
            let allUser = try viewContext.fetch(Users.fetchRequest())
            for user in allUser as! [Users] {
                if user.username == username {
                    if ((user.wishlistItems?.contains(Int(ProductID[indexPath.row])))!){
                        searchCell.wishlistBtn.setBackgroundImage(UIImage(systemName:"heart.fill"), for: .normal)
                    } else {
                        searchCell.wishlistBtn.setBackgroundImage(UIImage(systemName:"heart"), for: .normal)
                    }
                }
            }

        } catch {print(error)}
        searchCell.wishlistBtn.tag = Int(ProductID[indexPath.row])
        searchCell.wishlistBtn.addTarget(self, action: #selector(self.addToWishlist), for: .touchUpInside)
              
           return searchCell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        ID = ProductID[indexPath.row]
        performSegue(withIdentifier: "toProduct", sender: nil)
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
    
    @IBAction func SearchQuery(_ sender: UITextField) {
        query = searchTF.text!
        updateResult()
        animate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Results for '\(query)'"
        searchTF.text = query
        
        viewContext = app.persistentContainer.viewContext
        updateResult()
        animate()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toProduct" {
            let target = segue.destination as! ProductViewController
            target.productID = ID!
        }
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
        
        getResults(query: query, sortkey: sortkey, ascend: ascend)
        searchCollectionView.reloadData()
    }
    
    func getResults(query: String, sortkey: String, ascend: Bool){
        let fetchRequest: NSFetchRequest<Products> = Products.fetchRequest()
        let predicate = NSPredicate(format: "productName CONTAINS[cd] %@", query)
        let sort = NSSortDescriptor(key: sortkey, ascending: ascend)
        
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sort]
            
        do {
            let all = try viewContext.fetch(fetchRequest)
            for product in all {
                ProductID.append(product.id)
                ProductName.append(product.productName!)
                ProductImage.append(product.productImage!)
                ProductRating.append(Double(product.productRating))
                ProductPrice.append(product.productPrice)
                ProductSalePrice.append(product.salePrice)
                ProductIsOnSale.append(Int(product.isOnSale))
            }
        } catch {}
        
        print("Results loaded")
    }
    
    let fromAnimation = AnimationType.from(direction: .right, offset: 30.0)
    let zoomAnimation = AnimationType.zoom(scale: 0.2)
    let rotateAnimation = AnimationType.rotate(angle: CGFloat.pi/6)
    
    func animate() {
        searchCollectionView?.performBatchUpdates({
            UIView.animate(views: self.searchCollectionView!.orderedVisibleCells,
                animations: [fromAnimation, zoomAnimation, rotateAnimation], completion: {
                })
        }, completion: nil)
    }
}
