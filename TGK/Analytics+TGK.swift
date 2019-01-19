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
        //MARK: Events
        case eventViewDetails = "event_home_view_event"
        case eventVolunteerBannerClose = "event_volunteer_banner_close"
        case eventVolunteerBannerOpen = "event_volunteer_banner_open"
        
        //MARK: Donate/Give
        case donateOneTimeDonationStarted = "donation_one_time_started"
        case donateRecurringDonationStarted = "donation_recurring_started"
        
        //MARK: Forms
        case formViewDetails = "form_view_details" //segmentedFormInfoViewController
        case formStarted = "form_started"
        case formCompleted = "form_completed"
        
        ///MARK: SafetyNet
        case safetyNetChangeToLocationSearch = "safetynet_change_to_location_search"
        case safetyNetChangeToGlobalSearch = "safetynet_change_to_global_search"
        case safetyNetVisitWebsite = "safetynet_visit_website"
        case safetyNetVisitAddress = "safetynet_visit_address"
        case safetyNetCallPhone = "safetynet_call_phone"
        case safetyNetSearch = "safetynet_search"
        case safetyNetFacebookGroupVisit = "safetynet_visit_facebook_group"
        
        //MARK: About
        case newsletterSignupStarted = "newsletter_signup_started"
        case feedbackPositive = "feedback_positive"
        case feedbackComment = "feedback_comment"
        case feedbackReportProblem = "feedback_report_problem"
        
        //MARK: Learn More buttons
        case learnMorePressed = "learn_more_pressed"
    }
    
    enum CustomParameter:String {
        //MARK: Events
        case eventViewDetailsEventName = "event_name" ///title of event
        case eventViewDetailsEventUrl = "event_url" ///url of event
        
        //MARK: Forms
        case formName = "form_name" ///name of wufoo form
        case formId = "form_id" ///id of wufoo form
        
        //MARK: SafetNet
        case safetyNetName = "safetynet_name"
        case safetyNetSearchTerm = "search_term"
        case safetyNetSearchLocationBased = "is_location_based"
        case safetyNetFacebookGroupName = "facebook_group_name"
        
        //MARK: Learn More buttons
        case learnMoreType = "learn_more_type"
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
