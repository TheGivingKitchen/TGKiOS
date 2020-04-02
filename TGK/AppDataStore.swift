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
        case hasClosedEventHomeVolunteerButton = "hasClosedEventHomeVolunteerButton"
        case hasClosedQPRTrainingButton = "hasClosedQPRTrainingButton"
        case hasClosedStabilityNetOnboarding = "hasClosedStabilityNetOnboarding"
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
    
    static var hasClosedEventHomeVolunteerButton:Bool {
        get {
            return UserDefaults.standard.bool(forKey: AppDataStoreKey.hasClosedEventHomeVolunteerButton.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: AppDataStoreKey.hasClosedEventHomeVolunteerButton.rawValue)
        }
    }
    
    static var hasClosedStabilityNetOnboarding:Bool {
        get {
            return UserDefaults.standard.bool(forKey: AppDataStoreKey.hasClosedStabilityNetOnboarding.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: AppDataStoreKey.hasClosedStabilityNetOnboarding.rawValue)
        }
    }
}
