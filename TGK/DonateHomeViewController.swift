//
//  DonateHomeViewController.swift
//  TGK
//
//  Created by Jay Park on 6/6/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import UIKit
import SafariServices

class DonateHomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    
    @IBAction func mainDonationFormPressed(_ sender: Any) {
        let safariVC = TGKSafariViewController(url: URL(string: "https://connect.clickandpledge.com/w/Form/d11bff52-0cd0-44d8-9403-465614e4f342")!)
        self.present(safariVC, animated: true)
    }
    
}
