//
//  OrderViewController.swift
//  KangarooApp
//
//  Created by Damian on 25/2/22.
//  Copyright © 2022 ITE. All rights reserved.
//

import UIKit
import CoreData
import ViewAnimator

class OrderHistoryViewController: UIViewController, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    let Identifier = "orderHistoryCell"

    var ID:Int16?
    let username = UserDefaults.standard.string(forKey: "User")
    
    var UserHistory = [[Any]]()
    
    var ProductID = [Int16]()
    var ProductName = [String]()
    var ProductImage = [String]()
    var ProductQuantity = [Int]()
    var ProductPrice = [Double]()
    var OrderDate = [String]()
    var ProductColor = [String]()
    var ProductSize = [String]()
    
    @IBOutlet weak var HistoryCollectionView: UICollectionView!
    @IBOutlet weak var emptyLbl: UILabel!
    
    let app = UIApplication.shared.delegate as! AppDelegate
    var viewContext: NSManagedObjectContext!

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ProductID.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let HistoryCell = HistoryCollectionView.dequeueReusableCell(withReuseIdentifier: Identifier, for: indexPath) as! orderHistoryCell
        
        HistoryCell.orderHistoryImage.image = UIImage(named: ProductImage[indexPath.row])
        HistoryCell.orderHistoryName.text = ProductName[indexPath.row]
        HistoryCell.orderHistoryQuantity.text = String(OrderDate[indexPath.row])
        if (ProductColor[indexPath.row] != "-" && ProductSize[indexPath.row] != "-"){
            HistoryCell.orderHistoryVariant.text = String(ProductColor[indexPath.row]) + ", " + String(ProductSize[indexPath.row])
        } else {
            HistoryCell.orderHistoryVariant.text = "-"
        }
        HistoryCell.orderHistoryPrice.text = String(Int(ProductPrice[indexPath.row])) + " RC"

        return HistoryCell
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

    override func viewDidLoad() {
        super.viewDidLoad()
        resetValues()
            viewContext = app.persistentContainer.viewContext
            getOrderHistory(username: username!)
        
            if (ProductID.count == 0){
                emptyLbl.isHidden = false
                HistoryCollectionView.isHidden = true
            } else {
                emptyLbl.isHidden = true
                HistoryCollectionView.isHidden = false
                
                HistoryCollectionView.reloadData()
            }
        animate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func getOrderHistory(username: String) {
        do {
            let all = try viewContext.fetch(Users.fetchRequest())
            for user in all as! [Users] {
                if (user.username == username){
                    UserHistory = user.orderHistory!
                    print(UserHistory)
                }
            }
         } catch {print(error)}

        for item in UserHistory {
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
                        if(product.isOnSale == 1) {
                            ProductPrice.append(product.salePrice)
                        } else {
                            ProductPrice.append(product.productPrice)
                        }
                    }
                } catch {print(error)}
                ProductQuantity.append(item[1] as! Int)
                OrderDate.append(item[5] as! String)
                ProductColor.append(item[3] as! String)
                ProductSize.append(item[4] as! String)
            }
        }
        print("History loaded")
    }
    
    func resetValues() {
        ProductID.removeAll()
        ProductName.removeAll()
        ProductImage.removeAll()
        ProductQuantity.removeAll()
        ProductPrice.removeAll()
        OrderDate.removeAll()
        ProductColor.removeAll()
        ProductSize.removeAll()
    }
    
    let fromAnimation = AnimationType.from(direction: .right, offset: 30.0)
    let zoomAnimation = AnimationType.zoom(scale: 0.2)
    let rotateAnimation = AnimationType.rotate(angle: CGFloat.pi/6)
    
    func animate() {
        HistoryCollectionView?.performBatchUpdates({
            UIView.animate(views: self.HistoryCollectionView!.orderedVisibleCells,
                animations: [fromAnimation, zoomAnimation, rotateAnimation], completion: {
                })
        }, completion: nil)
    }
}
