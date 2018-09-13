//
//  SafetyNetResourceModel.swift
//  TGK
//
//  Created by Jay Park on 8/24/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import Foundation
import UIKit

struct SafetyNetResourceModel:Equatable {
    var name:String
    var address:String?
    var websiteUrl:URL?
    var phoneNumber:String?
    var contactName:String?
    var category:String?
    var resourceDescription:String?
    var counties:[String]?
    
    init(jsonDict: [String:Any]) {
        self.name = jsonDict["name"] as? String ?? ""
        self.phoneNumber = jsonDict["phone"] as? String
        self.phoneNumber = self.phoneNumber?.formatStringToNumericString()
        self.contactName = jsonDict["contactName"] as? String
        self.category = jsonDict["category"] as? String
        self.resourceDescription = jsonDict["description"] as? String
        
        if let addressString = jsonDict["address"] as? String {
            let trimmedAddressString = addressString.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmedAddressString.isEmpty == false {
                self.address = trimmedAddressString
            }
        }
        
        if let websiteString = jsonDict["website"] as? String {
            if let webUrl = URL(string: websiteString.trimmingCharacters(in: .whitespacesAndNewlines)) {
                let urlIsValid = UIApplication.shared.canOpenURL(webUrl)
                if urlIsValid {
                    self.websiteUrl = webUrl
                }
            }
        }
        
        if let countiesString = jsonDict["countiesServed"] as? String {
            let splitStringArray = countiesString.components(separatedBy: ",")
            let sanitizedArray = splitStringArray.filter { (county) -> Bool in
                if county.trimmingCharacters(in: .whitespaces).isEmpty {
                    return false
                }
                return true
            }
            let trimmedArray = sanitizedArray.map { (countyString) -> String in
                return countyString.trimmingCharacters(in: .whitespaces)
            }
            self.counties = trimmedArray
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
