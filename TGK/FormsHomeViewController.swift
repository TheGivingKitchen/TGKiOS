//
//  FormsHomeViewController.swift
//  TGK
//
//  Created by Jay Park on 5/20/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Alamofire
import FirebaseAuth

class FormsHomeViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func buttontapped(_ sender: Any) {
        UIApplication.shared.open(URL(string: "fb://group?id=1426736404312089")!, options: [:]) { (success) in
            if success == false {
                let tgkSafariVC = TGKSafariViewController(url: URL(string: "https://www.facebook.com/groups/1426736404312089")!)
                self.present(tgkSafariVC, animated: true)
            }
        }
    }
}
