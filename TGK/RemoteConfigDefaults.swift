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
    
    static var expirationDuration:TimeInterval {
        get {
            return 300.0// 5 minute throttle for remote config fetches
        }
    }
}
