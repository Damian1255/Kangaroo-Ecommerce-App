//
//  CustomTextField.swift
//  Project
//
//  Created by Damian on 15/8/21.
//  Copyright © 2021 Damian. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    // Provides left padding for images
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        return textRect
    }

    // Provides right padding for images
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.rightViewRect(forBounds: bounds)
        textRect.origin.x -= rightPadding
        return textRect
    }

    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }

    @IBInspectable var rightImage: UIImage? {
        didSet {
            updateRightView()
        }
    }

    @IBInspectable var leftPadding: CGFloat = 0
    @IBInspectable var rightPadding: CGFloat = 0
    @IBInspectable var gapPadding: CGFloat = 0
    @IBInspectable var color: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
    @IBInspectable var cornerRadius: CGFloat = 0
    @IBInspectable var borderColor: UIColor? = .lightGray
    @IBInspectable var borderWidth: CGFloat = 0

    override func draw(_ rect: CGRect) {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor?.cgColor
        
    }

    //@IBInspectable var roundCornersRadius: CGFloat = 0 {
      //  didSet{
         //   roundCornersRadiusTextField(radius: roundCornersRadius)
      //  }
    // }


    func roundCornersRadiusTextField(radius:CGFloat) {
           roundCorners(corners: [UIRectCorner.topLeft, UIRectCorner.topRight, UIRectCorner.bottomLeft, UIRectCorner.bottomRight], radius:radius)
       }

       func roundBottomCornersRadius(radius:CGFloat) {
           roundCorners(corners: [UIRectCorner.topLeft, UIRectCorner.topRight], radius:radius)
       }

    func updateView() {
        if let image = leftImage {
            leftViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = color
            leftView = imageView
        } else {
            leftViewMode = UITextField.ViewMode.never
            leftView = nil
        }
        
        // Placeholder text color
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: color])
    }


    func updateRightView() {
        if let image = rightImage {
            rightViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = color
            rightView = imageView
        } else {
            rightViewMode = UITextField.ViewMode.never
            rightView = nil
        }
        
        // Placeholder text color
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: color])
    }

    func roundCorners(corners:UIRectCorner, radius:CGFloat) {
            let bounds = self.bounds
            
            let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            
            let maskLayer = CAShapeLayer()
            maskLayer.frame = bounds
            maskLayer.path = maskPath.cgPath
            
            self.layer.mask = maskLayer
            
            let frameLayer = CAShapeLayer()
            frameLayer.frame = bounds
            frameLayer.path = maskPath.cgPath
            frameLayer.strokeColor = UIColor.darkGray.cgColor
            frameLayer.fillColor = UIColor.init(red: 247, green: 247, blue: 247, alpha: 0).cgColor
            
            self.layer.addSublayer(frameLayer)
        }

    private var textPadding: UIEdgeInsets {
        let p: CGFloat = leftPadding + gapPadding + (leftView?.frame.width ?? 0)
        return UIEdgeInsets(top: 0, left: p, bottom: 0, right: 5)
    }
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }

}
