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
        _ = formsHomeVC.view
        let formsHomeNavVC = UINavigationController(rootViewController: formsHomeVC)
        formsHomeNavVC.tabBarItem = UITabBarItem(title: "Forms", image: nil, selectedImage: nil)
        
        self.viewControllers = [formsHomeNavVC]
    }

}
