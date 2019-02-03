//
//  TGKSafariViewController.swift
//  TGK
//
//  Created by Jay Park on 6/9/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import UIKit
import SafariServices

class TGKSafariViewController: SFSafariViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.preferredControlTintColor = UIColor.tgkOrange
    }
}
