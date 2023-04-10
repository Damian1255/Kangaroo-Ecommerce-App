//
//  ConfirmViewController.swift
//  KangarooApp
//
//  Created by T04-09 on 4/3/22.
//  Copyright © 2022 ITE. All rights reserved.
//

import UIKit

class ConfirmViewController: UIViewController {

    var price: Int = 0
    
    @IBOutlet weak var msgLbl: UILabel!
    @IBOutlet weak var kangimage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        
        msgLbl.text = "Your payment of \(price) RC has been processed successfully!"
        
        UIView.animate(withDuration: 1, animations: {
            self.kangimage.frame.origin.y -= 180
        }){_ in
            UIView.animateKeyframes(withDuration: 1, delay: 0.25, options: [.autoreverse, .repeat], animations: {
                self.kangimage.frame.origin.y += 180
            })
        }
        
    }
    @IBAction func DoneBtn(_ sender: UIButton) {
        performSegue(withIdentifier: "toCart", sender: nil)
    }
    
    
}
