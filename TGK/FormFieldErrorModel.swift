//
//  FormErrorModel.swift
//  TGK
//
//  Created by Jay Park on 5/7/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import Foundation

struct FormFieldErrorModel {
    let wufooFieldId:String
    let errorText:String
    
    init(jsonDict:[String:Any]) {
        self.wufooFieldId = jsonDict["ID"] as? String ?? ""
        if let rawErrorText = jsonDict["ErrorText"] as? String {
            var sanitzedString = rawErrorText.replacingOccurrences(of: "<b>", with: "")
            sanitzedString = sanitzedString.replacingOccurrences(of: "</b>", with: "")
            self.errorText = sanitzedString
        }
        else {
            self.errorText = ""
        }
    }
}
