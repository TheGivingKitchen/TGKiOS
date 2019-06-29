//
//  SafetyNetResourceModel.swift
//  TGK
//
//  Created by Jay Park on 8/24/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import Foundation
import UIKit

struct SafetyNetResourceModel:Equatable, Codable {
    var name:String
    var address:String?
    var websiteUrl:URL?
    var phoneNumber:String?
    var contactName:String?
    var category:String?
    var resourceDescription:String?
    var counties:[String]?
    
    enum CodingKeys:String, CodingKey {
        case name
        case address
        case websiteUrl = "website"
        case phoneNumber = "phone"
        case contactName
        case category
        case resourceDescription = "description"
        case counties = "countiesServed"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        print(name)
        contactName = try container.decodeIfPresent(String.self, forKey: .contactName)
        resourceDescription = try container.decodeIfPresent(String.self, forKey: .resourceDescription)
        
        
        let addressUnsanitized = try container.decodeIfPresent(String.self, forKey: .address)
        if let addressUnsanitized = addressUnsanitized {
            let trimmedAddress = addressUnsanitized.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmedAddress.isEmpty == false {
                self.address = trimmedAddress
            }
        }
        
        let websiteString = try container.decodeIfPresent(String.self, forKey: .websiteUrl)
        if let websiteString = websiteString,
            let webUrl = URL(string: websiteString.trimmingCharacters(in: .whitespacesAndNewlines)) {
            let urlIsValid = UIApplication.shared.canOpenURL(webUrl)
            if urlIsValid {
                self.websiteUrl = webUrl
            }
        }
        
        let phoneNumberString = try container.decodeIfPresent(String.self, forKey: .phoneNumber)
        self.phoneNumber = phoneNumberString?.formatStringToNumericString()
        
        let countiesString = try container.decodeIfPresent(String.self, forKey: .counties)
        if let countiesString = countiesString {
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
    
//TODO still need to add custom encoder to match decoder
}
