//
//  Components.swift
//  KangarooApp
//
//  Created by Damian on 28/1/22.
//  Copyright © 2022 ITE. All rights reserved.
//
import Foundation
import UIKit

class Components {
    
    class func highlightBorder(target: UITextField, duration: Double, Width: Double, Color: UIColor) {
        if (target.layer.borderColor != Color.cgColor){
            target.layer.borderWidth = 0
            
            let animation = CABasicAnimation(keyPath: "borderWidth")
            animation.fromValue = target.layer.borderWidth
            animation.toValue = Width
            animation.duration = duration
            target.layer.add(animation, forKey: "borderWidth")
            
            target.layer.borderWidth = CGFloat(Width)
            target.layer.borderColor = Color.cgColor
        }
    }
    
    
    class func displayMessage(target: UILabel, msg: String, duration: Double){
        Timer.scheduledTimer(withTimeInterval: duration, repeats: false, block: {(timer) in
            target.isHidden = true
            target.text = msg
        })
        target.isHidden = false
        target.text = msg
    }
    
    class func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
