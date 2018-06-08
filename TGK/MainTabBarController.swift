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
        formsHomeNavVC.tabBarItem = UITabBarItem(title: "Testing", image: UIImage(named: ""), selectedImage: nil)
        
        let assistanceHomeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AssistanceHomeViewControllerId") as! AssistanceHomeViewController
        _ = assistanceHomeVC.view
        let assistanceHomeNavVC = UINavigationController(rootViewController: assistanceHomeVC)
        assistanceHomeNavVC.tabBarItem = UITabBarItem(title: "Assistance", image: UIImage(named: "tabBarRaisedHand"), selectedImage: nil)
        
        let eventsHomeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EventsHomeViewControllerId") as! EventsHomeViewController
        _ = eventsHomeVC.view
        let eventsHomeNavVC = UINavigationController(rootViewController: eventsHomeVC)
        eventsHomeNavVC.tabBarItem = UITabBarItem(title: "Events", image: UIImage(named: "tabBarCalendar"), selectedImage: nil)
        
        let donateHomeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DonateHomeViewControllerId") as! DonateHomeViewController
        _ = donateHomeVC.view
        let donateHomeNavVC = UINavigationController(rootViewController: donateHomeVC)
        donateHomeNavVC.tabBarItem = UITabBarItem(title: "Support", image: UIImage(named: "tabBarHeart"), selectedImage: nil)
        
        self.viewControllers = [formsHomeNavVC, assistanceHomeNavVC, eventsHomeNavVC, donateHomeNavVC]
    }

}
