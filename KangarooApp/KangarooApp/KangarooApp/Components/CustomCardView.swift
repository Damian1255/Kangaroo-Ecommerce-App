//
//  CustomCardView.swift
//  Project
//
//  Created by Damian on 13/8/21.
//  Copyright © 2021 Damian. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CustomCardView: UIView {

    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.shadowRadius = newValue
            layer.masksToBounds = false
        }
    }

    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
            layer.shadowColor = UIColor.lightGray.cgColor
        }
    }

    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
            layer.shadowColor = UIColor.lightGray.cgColor
            layer.masksToBounds = false
        }
    }
}
