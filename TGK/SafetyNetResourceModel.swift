//
//  SafetyNetResourceModel.swift
//  TGK
//
//  Created by Jay Park on 8/24/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class SafetyNetResourceModel:NSObject, Codable {
    
    static var allCategories:[String] = []
    
//    //TODO equitable implementation. remove now that we subclass nsobject?
//    static func == (lhs: SafetyNetResourceModel, rhs: SafetyNetResourceModel) -> Bool {
//        if lhs.name == rhs.name &&
//            lhs.address == rhs.address &&
//            lhs.websiteUrl?.absoluteString == rhs.websiteUrl?.absoluteString &&
//            lhs.phoneNumber == rhs.phoneNumber &&
//            lhs.contactName == rhs.contactName &&
//            lhs.category == rhs.category &&
//            lhs.resourceDescription == rhs.resourceDescription &&
//            lhs.counties == rhs.counties &&
//            lhs.location?.latitude == rhs.location?.latitude &&
//            lhs.location?.longitude == rhs.location?.longitude {
//            return true
//        }
//        return false
//    }
    
    
    var name:String
    var address:String?
    var websiteUrl:URL?
    var phoneNumber:String?
    var contactName:String?
    var category:String?
    var subcategories:[String]?
    var resourceDescription:String?
    var counties:[String]?
    var location:CLLocationCoordinate2D?
    
    enum CodingKeys:String, CodingKey {
        case name
        case address
        case websiteUrl = "website"
        case phoneNumber = "phone"
        case contactName
        case category
        case subcategories
        case resourceDescription = "description"
        case counties = "countiesServed"
        case location
        case latitude
        case longitude
    }
    
    
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        contactName = try container.decodeIfPresent(String.self, forKey: .contactName)
        category = try container.decodeIfPresent(String.self, forKey: .category)
        if let unwrappedCategory = category {
            if !SafetyNetResourceModel.allCategories.contains(unwrappedCategory) {
                SafetyNetResourceModel.allCategories.append(unwrappedCategory)
            }
        }
        
        subcategories = try container.decodeIfPresent([String].self, forKey: .subcategories)
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
        
        counties = try container.decodeIfPresent([String].self, forKey: .counties)
        
        let latidude = try container.decodeIfPresent(Double.self, forKey: .latitude)
        let longitude = try container.decodeIfPresent(Double.self, forKey: .longitude)
        
        if let lat = latidude,
            let long = longitude {
            location = CLLocationCoordinate2D(latitude: lat, longitude: long)
        }
        
        super.init()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(contactName, forKey: .contactName)
        try container.encodeIfPresent(category, forKey: .category)
        try container.encodeIfPresent(subcategories, forKey: .subcategories)
        try container.encodeIfPresent(resourceDescription, forKey: .resourceDescription)
        try container.encodeIfPresent(address, forKey: .address)
        try container.encodeIfPresent(websiteUrl?.absoluteString, forKey: .websiteUrl)
        try container.encodeIfPresent(phoneNumber, forKey: .phoneNumber)
        try container.encodeIfPresent(counties, forKey: .counties)
        try container.encodeIfPresent(location?.latitude, forKey: .latitude)
        try container.encodeIfPresent(location?.longitude, forKey: .longitude)
    }
    
    
}

//MARK: MKAnnotation conformance
extension SafetyNetResourceModel:MKAnnotation {
    var title: String? {
        return self.name
    }
    
    var subtitle: String? {
        return self.resourceDescription
    }
    
    var coordinate: CLLocationCoordinate2D {
        return self.location ?? kCLLocationCoordinate2DInvalid
    }

}
