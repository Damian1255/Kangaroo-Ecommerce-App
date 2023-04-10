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

class WishlistViewController: UIViewController, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    let Identifier = "wishlistCell"
    let username = UserDefaults.standard.string(forKey: "User")
    
    var ID:Int16?
    var userInfo = UserDefaults.standard
    
    var ProductID = [Int16]()
    var ProductName = [String]()
    var ProductImage = [String]()
    var ProductPrice = [Int16]()
    var ProductSalePrice = [Int16]()
    var ProductIsOnSale = [Int]()

    var productCategory:String = ""
    var sortkey: String = "productName"
    var ascend: Bool = true
    
    @IBOutlet weak var wishlistCollectionView: UICollectionView!
    @IBOutlet weak var emptyLbl: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    
    let app = UIApplication.shared.delegate as! AppDelegate
    var viewContext: NSManagedObjectContext!

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ProductID.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let wishlistCell = wishlistCollectionView.dequeueReusableCell(withReuseIdentifier: Identifier, for: indexPath) as! wishlistCell
        
        wishlistCell.wishlistImage.image = UIImage(named: ProductImage[indexPath.row])
        wishlistCell.wishlistName.text = ProductName[indexPath.row]
        
        wishlistCell.wishlistBtn.tag = Int(ProductID[indexPath.row])
        wishlistCell.wishlistBtn.addTarget(self, action: #selector(self.addToWishlist), for: .touchUpInside)
        
        if (ProductIsOnSale[indexPath.row] == 1) {
            let attributedText = NSAttributedString(
                string: String(Int(ProductPrice[indexPath.row])) + " RC",
                attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
            )
            wishlistCell.wishlistPrice.attributedText = attributedText
            
            wishlistCell.wishlistSalePrice.text = String(Int(ProductSalePrice[indexPath.row])) + " RC"
            wishlistCell.wishlistSalePrice.isHidden = false
        } else {
            wishlistCell.wishlistPrice.text = String(Int(ProductPrice[indexPath.row])) + " RC"
            wishlistCell.wishlistSalePrice.isHidden = true
        }
           
        return wishlistCell
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
    
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toProduct" {
            let target = segue.destination as! ProductViewController
            target.productID = ID!
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        ProductID.removeAll()
        ProductName.removeAll()
        ProductImage.removeAll()
        ProductPrice.removeAll()
        ProductSalePrice.removeAll()
        ProductIsOnSale.removeAll()
        
        viewContext = app.persistentContainer.viewContext
        getWishlist(username: username!, sortkey: sortkey, ascend: ascend)
        
        if (ProductID.count == 0){
            emptyLbl.isHidden = false
            wishlistCollectionView.isHidden = true
        } else {
            emptyLbl.isHidden = true
            wishlistCollectionView.isHidden = false
            wishlistCollectionView.reloadData()
        }
        animate()
        
        subLabel.text = "You have \(ProductID.count) items in your Wishlist."
    }
    
    func getWishlist(username: String, sortkey: String, ascend: Bool){
        var productIDs = [Int]()
        do {
            let all = try viewContext.fetch(Users.fetchRequest())
            for user in all as! [Users] {
                if (user.username == username){
                    productIDs = user.wishlistItems!
                }
            }
         } catch {}

        for id in productIDs {
            let fetchRequest: NSFetchRequest<Products> = Products.fetchRequest()
            let predicate = NSPredicate(format: "id like '" + String(id) + "'")
            let sort = NSSortDescriptor(key: sortkey, ascending: ascend)
            
            fetchRequest.predicate = predicate
            fetchRequest.sortDescriptors = [sort]
            
            do {
                let all = try viewContext.fetch(fetchRequest)
                for product in all {
                    ProductID.append(product.id)
                    ProductName.append(product.productName!)
                    ProductImage.append(product.productImage!)
                    ProductPrice.append(Int16(product.productPrice))
                    ProductSalePrice.append(Int16(product.salePrice))
                    ProductIsOnSale.append(Int(product.isOnSale))
                }
             } catch {}
        }
        print("wishlist loaded")
    }
    
    let fromAnimation = AnimationType.from(direction: .right, offset: 30.0)
    let zoomAnimation = AnimationType.zoom(scale: 0.2)
    let rotateAnimation = AnimationType.rotate(angle: CGFloat.pi/6)
    
    func animate() {
        wishlistCollectionView?.performBatchUpdates({
            UIView.animate(views: self.wishlistCollectionView!.orderedVisibleCells,
                animations: [fromAnimation, zoomAnimation, rotateAnimation], completion: {
                })
        }, completion: nil)
    }
}
