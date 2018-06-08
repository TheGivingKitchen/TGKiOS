//
//  ServiceRouter.swift
//  TGK
//
//  Created by Jay Park on 5/5/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import Foundation
import Alamofire

enum Router {
    static let wufooBaseUrl = "https://thegivingkitchen.wufoo.com/api/v3"
    static let firebaseBaseStorageUrl = "https://firebasestorage.googleapis.com/v0/b/thegivingkitchen-cdd28.appspot.com/o"
    static let givingKitchenBaseUrl = "https://thegivingkitchen.org"
    static let firebaseBaseApiUrl = "https://thegivingkitchen-cdd28.firebaseio.com"
    
    //Root
    case getAppConfiguration
    //Forms
    case getAllWufooForms
    case getWufooForm(String)
    
    case getFirebaseForm(String)
    case postFormEntry(String)
    
    //Events
    case getEventFeed
}

extension Router {
    var httpMethod:Alamofire.HTTPMethod {
        switch self {
        //Root
        case .getAppConfiguration:
            return .get
        //Forms
        case .getAllWufooForms:
            return .get
        case .getWufooForm:
            return .get
        case .getFirebaseForm:
            return .get
        case .postFormEntry:
            return .post
        //Events
        case .getEventFeed:
            return .get
        }
    }
    
    var urlString:String {
        switch self {
        //Root
        case .getAppConfiguration:
            return "\(Router.firebaseBaseApiUrl)/root.json"
        //Forms
        case .getAllWufooForms:
            return "\(Router.wufooBaseUrl)/forms.json"
        case .getWufooForm(let formId):
            return "\(Router.wufooBaseUrl)/forms/\(formId)/fields.json"
        case .getFirebaseForm(let formId):
            return "\(Router.firebaseBaseStorageUrl)/forms%2F\(formId).json?alt=media"
        case .postFormEntry(let formId):
            return "\(Router.wufooBaseUrl)/forms/\(formId)/entries.json"
            
        //Events
        case .getEventFeed:
            return "\(Router.givingKitchenBaseUrl)/events-calendar"
        }
    }
    
    var url:URL {
        return URL(string: self.urlString)!
    }


}
