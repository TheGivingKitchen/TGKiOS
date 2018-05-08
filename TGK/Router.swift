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
    static let wufooBaseUrl = "https://thegivingkitchen.wufoo.com/api/v3/"
    
    case getAllForms
    case getForm(String)
    case postFormEntry(String)
}

extension Router {
    var httpMethod:Alamofire.HTTPMethod {
        switch self {
        case .getAllForms:
            return .get
        case .getForm:
            return .get
        case .postFormEntry:
            return .post
        }
    }
    
    var urlString:String {
        switch self {
        case .getAllForms:
            return "\(Router.wufooBaseUrl)/forms.json"
        case .getForm(let formId):
            return "\(Router.wufooBaseUrl)/forms/\(formId)/fields.json"
        case .postFormEntry(let formId):
            return "\(Router.wufooBaseUrl)/forms/\(formId)/entries.json"
        }
    }
    
    var url:URL {
        return URL(string: self.urlString)!
    }


}
