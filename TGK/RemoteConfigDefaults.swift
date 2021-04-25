//
//  RemoteConfigManager.swift
//  TGK
//
//  Created by Jay Park on 6/9/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import Foundation

//Class for holding app remote config keys synced with Firebase Remote Config
enum RemoteConfigDefaults:String {
    
    case isLive = "isLive" //Main killswitch for the app
    case donateOneTimeURL = "donateOneTimeURL"
    case donateRecurringURL = "donateRecurringURL"
    
    var defaultValue:NSObject {
        get {
            switch self {
            case .isLive:
                return true as NSObject
            case .donateOneTimeURL:
                return "https://connect.clickandpledge.com/w/Form/d00e52d7-f298-4d35-8be9-05fd93d3194a" as NSObject
            case .donateRecurringURL:
                return "https://www.classy.org/give/321559/#!/donation/checkout" as NSObject
            }
        }
    }
    
    static var expirationDuration:TimeInterval {
        get {
            var expiration:TimeInterval = 300.0 // 5 minute throttle for remote config fetches
            
            #if DEBUG
            expiration = 0
            #endif
            
            return expiration
        }
    }
    
    static var defaults:[String:NSObject] {
        get {
            return [self.isLive.rawValue:true as NSObject,
                    self.donateOneTimeURL.rawValue:self.donateOneTimeURL.defaultValue,
                    self.donateRecurringURL.rawValue:self.donateRecurringURL.defaultValue]
        }
    }
    
    
}
