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
        formsHomeNavVC.tabBarItem = UITabBarItem(title: "Support", image: UIImage(named: "tabBarRaisedHand"), selectedImage: nil)
        
        let vc = UIViewController()
        vc.tabBarItem = UITabBarItem(title: "Assistance", image: UIImage(named: "tabBarHeart"), tag: 0)
        
        
        self.viewControllers = [formsHomeNavVC, vc]
    }

}
