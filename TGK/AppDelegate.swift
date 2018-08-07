//
//  AppDelegate.swift
//  TGK
//
//  Created by Jay Park on 5/4/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseRemoteConfig
import FirebaseAuth
import Stripe

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var remoteConfigExpirationDuration:Double = 300 //5 minute throttle on remote config fetches


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        self.setupAppearances()
        
        self.setupRemoteConfig()
        Auth.auth().signInAnonymously { (result, error) in
            
        }
        
        STPPaymentConfiguration.shared().publishableKey = "pk_test_N0P215RKBn56kFCcBlgzxCxX"
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

//MARK: Appearance Proxy
extension AppDelegate {
    func setupAppearances() {
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().backgroundColor = UIColor.tgkBlue
        UITabBar.appearance().tintColor = UIColor.tgkOrange
        
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().tintColor = UIColor.tgkBlue
        UINavigationBar.appearance().titleTextAttributes = [.font:UIFont.tgkNavigation]
        
        UIBarButtonItem.appearance().setTitleTextAttributes([.font:UIFont.tgkBody], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([.font:UIFont.tgkBody], for: .highlighted)
    }
}

//MARK: Remote Config
extension AppDelegate {
    func setupRemoteConfig() {
        let remoteConfig = RemoteConfig.remoteConfig()
        
        #if DEBUG
        remoteConfig.configSettings = RemoteConfigSettings(developerModeEnabled: true)
        self.remoteConfigExpirationDuration = 0
        #endif
        
        let defaultConfigValues = [RemoteConfigDefaults.isLive.rawValue:true as NSObject]
        remoteConfig.setDefaults(defaultConfigValues)
    }
    
    func fetchRemoteConfigAndActivate() {
        RemoteConfig.remoteConfig().fetch(withExpirationDuration: self.remoteConfigExpirationDuration) { (status, error) in
            switch status {
            case .success:
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

