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
import FirebaseMessaging
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        self.setupAppearances()
        
        self.setupRemoteConfig()
        
        Auth.auth().signInAnonymously { (result, error) in
        }
        
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        
        //TODO TESTING PUSH NOTIFICATIONS
        /*
        let notificationOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: notificationOptions) { (granted, error) in
            
        }
 
        //TODO end remove
        */
        application.registerForRemoteNotifications()
        
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
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
    
    func topViewController() -> UIViewController? {
        guard let window = UIApplication.shared.keyWindow, let rootViewController = window.rootViewController else {
            return nil
        }
        
        var topViewController = rootViewController
        
        while let newTopController = topViewController.presentedViewController {
            topViewController = newTopController
        }
        
        return topViewController
    }
}

//MARK: Appearance Proxy
extension AppDelegate {
    func setupAppearances() {
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().backgroundColor = UIColor.tgkBlue
        UITabBar.appearance().tintColor = UIColor.tgkOrange
        UITabBarItem.appearance().setTitleTextAttributes([.font:UIFont.robotoMono(size: 11.0)], for: .normal)
        
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().tintColor = UIColor.tgkBlue
        UINavigationBar.appearance().titleTextAttributes = [.font:UIFont.tgkNavigation, .foregroundColor:UIColor.tgkDarkBlue]
        
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
        #endif
        
        remoteConfig.setDefaults(RemoteConfigDefaults.defaults)
        
        self.fetchRemoteConfigAndActivate()
        print("Done")
    }
    
    func fetchRemoteConfigAndActivate() {
        RemoteConfig.remoteConfig().fetch(withExpirationDuration: RemoteConfigDefaults.expirationDuration) { (status, error) in
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


//MARK: Push notifications
extension AppDelegate: UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    }
    
    //Fires when about to present a notification in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        completionHandler([.alert, .sound])
    }
    
    //Fires when tapping into a notification from anywhere
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        if let presentUrlString = userInfo["display_url"] as? String,
            let parsedUrl = URL(string: presentUrlString),
            let topVC = self.topViewController() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                let tgkSafariVC = TGKSafariViewController(url: parsedUrl)
                topVC.present(tgkSafariVC, animated: true)
            })
        }
        
        completionHandler()
    }
}

extension AppDelegate: MessagingDelegate {
    //This callback is fired at each app startup and whenever a new token is generated.
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("FCM push token:\(fcmToken)")
    }
}

