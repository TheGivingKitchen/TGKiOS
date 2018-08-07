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
import Stripe

class FormsHomeViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func postCharge(_ sender: Any) {
        let cardParams = STPCardParams()
        cardParams.number = "4242424242424242"
        cardParams.expMonth = 10
        cardParams.expYear = 2022
        cardParams.cvc = "111"
        
        STPAPIClient.shared().createToken(withCard: cardParams) { (token, error) in
            if let token = token {
                Alamofire.request("https://thegivingkitchen-cdd28.firebaseio.com/stripe_customers.json", method: .post, parameters:["amount":2500,"source":token.card?.stripeID], encoding: JSONEncoding.default).responseJSON { (response) in
                    switch response.result {
                    case .success(let value):
                        print("success")
                    case .failure:
                        print("fail")
                    }
                }
            }
            else {
                print(error!)
            }
        }
        
    }
}
