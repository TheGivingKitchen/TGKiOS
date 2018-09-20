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
        
        ///SafetyNet
        case safetyNetVisitWebsite = "safetynet_visit_website"
        case safetyNetVisitAddress = "safetynet_visit_address"
        case safetyNetCallPhone = "safetynet_call_phone"
        case safetyNetSearch = "safetynet_search"
    }
    
    enum CustomParameter:String {
        ///Events
        case eventViewDetailsEventName = "event_name" ///title of event
        case eventViewDetailsEventUrl = "event_url" ///url of event
        
        ///Forms
        case formName = "form_name" ///name of wufoo form
        case formId = "form_id" ///id of wufoo form
        
        ///SafetNet
        case safetyNetName = "safetynet_name"
        case safetyNetSearchTerm = "safetynet_search_term"
        case safetyNetSearchLocationBased = "safetynet_search_is_location_based"
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
