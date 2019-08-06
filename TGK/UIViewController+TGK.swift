//
//  UIViewController+TGK.swift
//  TGK
//
//  Created by Jay Park on 7/14/19.
//  Copyright © 2019 TheGivingKitchen. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    private var defaultViewControllerCornerRadius:Double{
        get {
            return 15.0
        }
    }
    
    func roundTopCorners() {
        self.roundTopCorners(cornerRadius: self.defaultViewControllerCornerRadius)
    }
    func roundTopCorners(cornerRadius: Double) {
        self.view.layer.cornerRadius = CGFloat(cornerRadius)
        self.view.clipsToBounds = true
        self.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}
