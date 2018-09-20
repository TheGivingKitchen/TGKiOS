//
//  Analytics+TGK.swift
//  TGK
//
//  Created by Jay Park on 9/17/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import Foundation
import Firebase

extension Analytics {
    enum CustomName:String {
        ///Events
        case eventViewDetails = "event_home_view_event"
        
        ///Donate/Give
        case donateOneTimeDonationStarted = "donation_one_time_started"
        case donateRecurringDonationStarted = "donation_recurring_started"
        
        ///Forms
        case formViewDetails = "form_view_details"
        case formStarted = "form_started"
        case formCompleted = "form_completed"
    }
    
    enum CustomParameter:String {
        ///Events
        case eventViewDetailsEventName = "event_name" ///title of event
        case eventViewDetailsEventUrl = "event_url" ///url of event
        
        ///Forms
        case formName = "form_name" ///name of wufoo form
        case formId = "form_id" ///id of wufoo form
    }
    
    static func logEvent(customName: Analytics.CustomName, parameters:[CustomParameter:Any]? = nil) {
        
        if let params = parameters {
            var stringKeyDict:[String:Any] = [:]
            for (key, value) in params {
                stringKeyDict[key.rawValue] = value
            }
            Analytics.logEvent(customName.rawValue, parameters: stringKeyDict)
        }
        else {
            Analytics.logEvent(customName.rawValue, parameters: nil)
        }
    }
}
