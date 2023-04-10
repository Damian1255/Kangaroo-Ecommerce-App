//
//  collectionViews.swift
//  KangarooApp
//
//  Created by Damian on 12/2/22.
//  Copyright © 2022 ITE. All rights reserved.
//

import UIKit

class newArrivalsCell: UICollectionViewCell {
    @IBOutlet weak var newArrivalsProductImage: UIImageView!
    @IBOutlet weak var newArrivalsProductName: UILabel!
    @IBOutlet weak var newDesc: UILabel!
    @IBOutlet weak var newPrice: UILabel!
}

class categoryCell: UICollectionViewCell {
    @IBOutlet weak var categoryLabel: UILabel!
}

class salesCell: UICollectionViewCell {
    @IBOutlet weak var saleProductImage: UIImageView!
    @IBOutlet weak var saleProductName: UILabel!
    @IBOutlet weak var saleRating: CosmosView!
    @IBOutlet weak var salePrice: UILabel!
    @IBOutlet weak var saleSalePrice: UILabel!
}

class discoveryCell: UICollectionViewCell {
    @IBOutlet weak var discoveryImage: UIImageView!
    @IBOutlet weak var discoveryName: UILabel!
    @IBOutlet weak var discoveryRating: CosmosView!
    @IBOutlet weak var discoveryPrice: UILabel!
    @IBOutlet weak var discoverySalePrice: UILabel!
    @IBOutlet weak var wishlistBtn: UIButton!
}

class displaycategoryCell: UICollectionViewCell {
    @IBOutlet weak var displaycategoryImage: UIImageView!
    @IBOutlet weak var displaycategoryName: UILabel!
    @IBOutlet weak var displayRating: CosmosView!
    @IBOutlet weak var displayPrice: UILabel!
    @IBOutlet weak var displaySalePrice: UILabel!
    @IBOutlet weak var wishlistBtn: UIButton!
}

class wishlistCell: UICollectionViewCell {
    @IBOutlet weak var wishlistImage: UIImageView!
    @IBOutlet weak var wishlistName: UILabel!
    @IBOutlet weak var wishlistBtn: UIButton!
    @IBOutlet weak var wishlistPrice: UILabel!
    @IBOutlet weak var wishlistSalePrice: UILabel!
}

class searchCell: UICollectionViewCell {
    @IBOutlet weak var searchImage: UIImageView!
    @IBOutlet weak var searchName: UILabel!
    @IBOutlet weak var searchRating: CosmosView!
    @IBOutlet weak var searchPrice: UILabel!
    @IBOutlet weak var searchSalePrice: UILabel!
    @IBOutlet weak var wishlistBtn: UIButton!
}

class cartCell: UICollectionViewCell {
    @IBOutlet weak var cartImage: UIImageView!
    @IBOutlet weak var cartName: UILabel!
    @IBOutlet weak var cartPrice: UILabel!
    @IBOutlet weak var cartSelector: UIButton!
    @IBOutlet weak var cartRemoveBtn: UIButton!
    @IBOutlet weak var cartQuantity: UILabel!
    @IBOutlet weak var quantityStepper: UIStepper!
    @IBOutlet weak var variantLbl: UILabel!
}

class orderHistoryCell: UICollectionViewCell {
    @IBOutlet weak var orderHistoryImage: UIImageView!
    @IBOutlet weak var orderHistoryName: UILabel!
    @IBOutlet weak var orderHistoryPrice: UILabel!
    @IBOutlet weak var orderHistoryQuantity: UILabel!
    @IBOutlet weak var orderHistoryVariant: UILabel!
}

class collectionCell: UICollectionViewCell {
    @IBOutlet weak var collectionImage: UIImageView!
    @IBOutlet weak var collectionName: UILabel!
    @IBOutlet weak var collectionRating: CosmosView!
    @IBOutlet weak var collectionPrice: UILabel!
    @IBOutlet weak var collectionSalePrice: UILabel!
    @IBOutlet weak var wishlistBtn: UIButton!
}

