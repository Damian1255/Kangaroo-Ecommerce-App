//
//  ProductsViewController.swift
//  KangarooApp
//
//  Created by Damian on 6/2/22.
//  Copyright © 2022 ITE. All rights reserved.
//

import UIKit
import CoreData

class Product: UIViewController {

    let app = UIApplication.shared.delegate as! AppDelegate
    var viewContext: NSManagedObjectContext!
    
    func loadProduct() {
        viewContext = app.persistentContainer.viewContext
        
        let id = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13]
        let isFeatured = [0, 0, 1, 1, 1, 0, 1, 0, 0, 0, 1, 0, 0]
        let isOnSale = [1, 0, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 1]
        let productCategory = ["Tools", "Tools", "Tools", "Tools", "Plants", "Fertilizer", "Fertilizer", "Gloves", "Gloves", "Shovels", "Shovels", "Shears", "Hose"]
        let productColour = ["Green,Red", "Blue,Red", "White,Red", "White", "-", "-", "-", "Green,White,Black", "Green,White", "Orange", "Black", "Black", "Red", "Green"]
        let productSize = ["500ml", "500ml", "500ml", "500ml", "-", "1L", "1L", "Small,Medium,Large","Small,Medium,Large", "-", "-", "-", "-", "10m"]
        let productDesc = ["This watering can is made of rust-resistant galvanised steel. Store it near plants to remind yourself to water them – and the plants will like you as much as you like them", "The watering cans comes with comfortable handle design and sprinkler holder that easy to hang the sprinkler. The spray head can be disassembled and can be switched to water column for irrigation, Great for both indoor and outdoor plants.", "Holds about 1 gallon of water (4L). With two comfortable handles and the top one can be adjusted. Can be used for outdoor and indoor plants", "The watering pot is made of high quality Plastics, Thick wall of the kettle, anti-fall and compression, Not easy to age or break. It is necessity as lawn & garden watering equipment.", "Show your plants some love with this elegant, vintage-inspired macrame plant. Simple, this beauty would add a touch of elegance and beauty to your home, balcony or your patio", "promotes soil health, biodiversity, and helps retain carbon contents longer in the soil. It is the result of years of research and extensive field tests all over the world.", "Develops abundant flowers & fruit and helps plants become more drought and disease resistant", "Ultra Cool and Very Comfortable to Wear, Breathable Coating Keeps Hands Cool and Dry", "Lightweight & dexterous work gloves - Ultra-stretch spandex panels between fingers for increased comfort", "Soft, contoured handles are ergonomically designed to reduce hand and wrist fatigue while working", "Curved heads and forked tines make breaking up tough soil easy", "this garden shears is very sharp and durable. It is ideal use for trimming and cutting the rose bush, shrubs, hedges, plant etc.", "Flexible garden hose comes equipped with 9-Pattern Spray Nozzle, which is slip-resistant and comfortable to use"]
        let productImage = ["can1", "can2", "can3", "can4", "hangingplant1", "fert1", "fert2", "gardenglove4", "gardenglove5", "shovel7", "shovel3", "shears1", "gardenhose1"]
        let productName = ["Watering Can - Green", "Watering Can - Blue", "Watering Can - White", "Watering Can - White", "Averplant", "PowerFeed Fertilizer", "Horti Bloom Fertilizer", "Essential Gardening Gloves", "Rayer Gardening Gloves", "Essential Shovel", "Stinky Shovel", "Grand Shears", "Nosey Hose"]
        let productPrice = [10, 24, 10, 34, 20, 36, 74, 37, 25, 28, 18, 15, 10]
        let salePrice = [9, 40, 8, 0, 15, 24, 46, 27, 20, 25, 13, 13, 8]
        let rating = [3, 5, 4, 5, 4.5, 4.8, 5, 4.2, 5, 5, 4.3, 3.8, 5]
        
        for index in 0...(id.count-1) {
            let product = NSEntityDescription.insertNewObject(forEntityName: "Products", into: viewContext) as! Products
            product.id = Int16(id[index])
            product.isFeatured = Int16(isFeatured[index])
            product.isOnSale = Int16(isOnSale[index])
            product.productCategory = productCategory[index]
            product.productColour = productColour[index]
            product.productDesc = productDesc[index]
            product.productImage = productImage[index]
            product.productSize = productSize[index]
            product.productName = productName[index]
            product.productPrice = Double(productPrice[index])
            product.salePrice = Double(salePrice[index])
            product.productRating = Float(rating[index])
        }
        
        app.saveContext()
    }
    
    func queryAllProducts() {
        viewContext = app.persistentContainer.viewContext
        
        do {
            let allProduct = try viewContext.fetch(Products.fetchRequest())

            for product in allProduct as! [Products] {
                print("\(product.id), \(product.productName ?? ""), \(product.productPrice), \(product.productImage ?? "")")
            }
        }
        catch{print(error)}
    }
    
    func deleteAllProducts() {
        viewContext = app.persistentContainer.viewContext
        
        let batch = NSBatchDeleteRequest(fetchRequest: Products.fetchRequest())

        do {
            try app.persistentContainer.persistentStoreCoordinator.execute(batch, with: viewContext)
        }
        catch{
            print(error)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
