//
//  MainTabBarController.swift
//  TGK
//
//  Created by Jay Park on 5/20/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let formsHomeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FormsHomeViewControllerId") as! FormsHomeViewController
        formsHomeVC.tabBarItem = UITabBarItem(title: "Forms", image: nil, selectedImage: nil)
        _ = formsHomeVC.view
        
        self.viewControllers = [formsHomeVC]
    }

}
