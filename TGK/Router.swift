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
    static let firebaseBaseFormUrl = "https://firebasestorage.googleapis.com/v0/b/thegivingkitchen-cdd28.appspot.com/o"
    
    case getAllForms
    case getWufooForm(String)
    case getFirebaseForm(String)
    case postFormEntry(String)
}

extension Router {
    var httpMethod:Alamofire.HTTPMethod {
        switch self {
        case .getAllForms:
            return .get
        case .getWufooForm:
            return .get
        case .getFirebaseForm:
            return .get
        case .postFormEntry:
            return .post
        }
    }
    
    var urlString:String {
        switch self {
        case .getAllForms:
            return "\(Router.wufooBaseUrl)/forms.json"
        case .getWufooForm(let formId):
            return "\(Router.wufooBaseUrl)/forms/\(formId)/fields.json"
        case .getFirebaseForm(let formId):
            return "\(Router.firebaseBaseFormUrl)/forms%2F\(formId).json?alt=media"
        case .postFormEntry(let formId):
            return "\(Router.wufooBaseUrl)/forms/\(formId)/entries.json"
        }
    }
    
    var url:URL {
        return URL(string: self.urlString)!
    }


}
