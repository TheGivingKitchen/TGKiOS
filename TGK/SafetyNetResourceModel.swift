//
//  SafetyNetResourceModel.swift
//  TGK
//
//  Created by Jay Park on 8/24/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import Foundation

struct SafetyNetResourceModel:Equatable {
    var name:String
    var address:String?
    var websiteUrlString:String?
    var phoneNumber:String?
    var contactName:String?
    var category:String?
    var resourceDescription:String?
    var counties:[String]?
    
    init(jsonDict: [String:Any]) {
        self.name = jsonDict["name"] as? String ?? ""
        self.address = jsonDict["address"] as? String
        self.websiteUrlString = jsonDict["website"] as? String
        self.phoneNumber = jsonDict["phone"] as? String
        self.phoneNumber = self.phoneNumber?.formatStringToNumericString()
        self.contactName = jsonDict["contactName"] as? String
        self.category = jsonDict["category"] as? String
        self.resourceDescription = jsonDict["description"] as? String
        
        if let countiesString = jsonDict["countiesServed"] as? String {
            let splitStringArray = countiesString.components(separatedBy: ",")
            let sanitizedArray = splitStringArray.map { (countyString) -> String in
                return countyString.trimmingCharacters(in: .whitespaces)
            }
            self.counties = sanitizedArray
        }
    }
    
    static func modelsWithJsonArray(jsonArray:[[String:Any]]) -> [SafetyNetResourceModel] {
        var allModels:[SafetyNetResourceModel] = []
        for jsonDict in jsonArray {
            allModels.append(SafetyNetResourceModel(jsonDict: jsonDict))
        }
        
        return allModels
    }
}
