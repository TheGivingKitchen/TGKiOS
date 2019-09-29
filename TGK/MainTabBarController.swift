//
//  MainTabBarController.swift
//  TGK
//
//  Created by Jay Park on 5/20/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import UIKit
import FirebaseRemoteConfig

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.unselectedItemTintColor = UIColor.tgkBlue
        
        let testHomeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TestHomeViewControllerId") as! TestHomeViewController
        _ = testHomeVC.view
        let testHomeNavVC = UINavigationController(rootViewController: testHomeVC)
        testHomeNavVC.tabBarItem = UITabBarItem(title: "Testing", image: UIImage(named: ""), selectedImage: nil)
        
        let assistanceHomeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AssistanceHomeViewControllerId") as! AssistanceHomeViewController
        _ = assistanceHomeVC.view
        let assistanceHomeNavVC = UINavigationController(rootViewController: assistanceHomeVC)
        assistanceHomeNavVC.tabBarItem = UITabBarItem(title: "Assistance", image: UIImage(named: "tabBarAssistance"), selectedImage: nil)
        
        let eventsHomeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EventsHomeViewControllerId") as! EventsHomeViewController
        _ = eventsHomeVC.view
        let eventsHomeNavVC = UINavigationController(rootViewController: eventsHomeVC)
        eventsHomeNavVC.tabBarItem = UITabBarItem(title: "Events", image: UIImage(named: "tabBarEvents"), selectedImage: nil)
        
        let donateHomeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DonateHomeViewControllerId") as! DonateHomeViewController
        _ = donateHomeVC.view
        let donateHomeNavVC = UINavigationController(rootViewController: donateHomeVC)
        donateHomeNavVC.tabBarItem = UITabBarItem(title: "Give", image: UIImage(named: "tabBarDonate"), selectedImage: nil)
        
        let stabilityNetHomeVC = UIStoryboard(name: "SafetyNet", bundle: nil).instantiateViewController(withIdentifier: "StabilityNetMapViewControllerId") as! StabilityNetMapViewController
        _ = stabilityNetHomeVC.view
        let safetyNetNavVC = UINavigationController(rootViewController: stabilityNetHomeVC)
        safetyNetNavVC.tabBarItem = UITabBarItem(title: "Resources", image: UIImage(named: "tabBarSafetyNet"), selectedImage: nil)
        
        let aboutHomeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AboutHomeViewControllerId") as! AboutHomeViewController
        _ = aboutHomeVC.view
        aboutHomeVC.tabBarItem = UITabBarItem(title: "About", image: UIImage(named: "tabBarHome"), selectedImage: nil)
        
        #if DEBUG
        self.viewControllers = [aboutHomeVC, eventsHomeNavVC, assistanceHomeNavVC, safetyNetNavVC, donateHomeNavVC, testHomeNavVC]
        #else
        self.viewControllers = [aboutHomeVC, eventsHomeNavVC, assistanceHomeNavVC, safetyNetNavVC, donateHomeNavVC]
        #endif
        
        //Remote config
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActiveHander(_:)), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if AppDataStore.hasFinishedOnboarding == false {
            let onboardingVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OnboardingViewControllerId") as! OnboardingViewController
            let onboardingNavVC = UINavigationController(rootViewController: onboardingVC)
            onboardingVC.delegate = self
            self.present(onboardingNavVC, animated: true)
        }
    }
    
    @objc private func applicationDidBecomeActiveHander(_ notification:NSNotification) {
        self.fetchRemoteConfigAndActivate()
    }
}

//MARK: Remote Config needs to be in application's entry view controller
extension MainTabBarController {
    func fetchRemoteConfigAndActivate() {
        RemoteConfig.remoteConfig().fetch(withExpirationDuration: RemoteConfigDefaults.expirationDuration) { (status, error) in
            switch status {
            case .success:
                print("Remote config fetch success. Activating values")
                RemoteConfig.remoteConfig().activateFetched()
                break
            case .failure:
                break
            default:
                break
            }
        }
    }
}

extension MainTabBarController:OnboardingViewControllerDelegate {
    func onboardingViewControllerDidFinish(viewController: OnboardingViewController) {
        viewController.dismiss(animated: true)
    }
}

