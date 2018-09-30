//
//  AppDataStore.swift
//  TGK
//
//  Created by Jay Park on 8/30/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import Foundation

class AppDataStore {
    private enum AppDataStoreKey:String {
        case closedSafetyNetTooltip = "closedSafetyNetTooltipKey"
        case hasFinishedOnboarding = "hasFinishedOnboarding"
    }
    
    static var hasFinishedOnboarding:Bool {
        get {
            return UserDefaults.standard.bool(forKey: AppDataStoreKey.hasFinishedOnboarding.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: AppDataStoreKey.hasFinishedOnboarding.rawValue)
        }
    }
    
    static var hasClosedSafetyNetTooltip:Bool {
        get {
            return UserDefaults.standard.bool(forKey: AppDataStoreKey.closedSafetyNetTooltip.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: AppDataStoreKey.closedSafetyNetTooltip.rawValue)
        }
    }
}
