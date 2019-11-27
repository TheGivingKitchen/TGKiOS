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
    var address:String? {
        get {
            //naive check for the rest of the address
            guard var formattedAddress = self.address1 else {
                return nil
            }
            if let address2 = self.address2 {
                formattedAddress += " \(address2)"
            }
            if let city = self.city {
                formattedAddress += ", \(city)"
            }
            if let state = self.state {
                formattedAddress += ", \(state)"
            }
            if let zip = self.zip {
                formattedAddress += " \(zip)"
            }
            return formattedAddress
        }
    }
    var address1:String?
    var address2:String?
    var city:String?
    var state:String?
    var zip:String?
    var websiteUrl:URL?
    var phoneNumber:String?
    var contactName:String?
    var category:String
    var subcategories:[String]
    var resourceDescription:String?
    var counties:[String]?
    var location:CLLocationCoordinate2D?
    var keywords:[String]
    
    enum CodingKeys:String, CodingKey {
        case name
        case address1 = "address1"
        case address2 = "address2"
        case city
        case state
        case zip
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
        case keywords
    }
    
    
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        contactName = try container.decodeIfPresent(String.self, forKey: .contactName)
        category = try container.decodeIfPresent(String.self, forKey: .category) ?? ""
        if !SafetyNetResourceModel.allCategories.contains(category) {
            SafetyNetResourceModel.allCategories.append(category)
        }
        
        subcategories = try container.decodeIfPresent([String].self, forKey: .subcategories) ?? []
        resourceDescription = try container.decodeIfPresent(String.self, forKey: .resourceDescription)
        
        address1 = try container.decodeIfPresent(String.self, forKey: .address1)
        address2 = try container.decodeIfPresent(String.self, forKey: .address2)
        city = try container.decodeIfPresent(String.self, forKey: .city)
        state = try container.decodeIfPresent(String.self, forKey: .state)
        zip = try container.decodeIfPresent(String.self, forKey: .zip)
        
        let websiteString = try container.decodeIfPresent(String.self, forKey: .websiteUrl)
        if let websiteString = websiteString,
            let webUrl = URL(string: websiteString.trimmingCharacters(in: .whitespacesAndNewlines)) {
            let urlIsValid = UIApplication.shared.canOpenURL(webUrl)
            if urlIsValid {
                self.websiteUrl = webUrl
            }
        }
        
        self.phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber)
        
        counties = try container.decodeIfPresent([String].self, forKey: .counties)
        
        let latidude = try container.decodeIfPresent(Double.self, forKey: .latitude)
        let longitude = try container.decodeIfPresent(Double.self, forKey: .longitude)
        
        if let lat = latidude,
            let long = longitude {
            location = CLLocationCoordinate2D(latitude: lat, longitude: long)
        }
        
        keywords = try container.decodeIfPresent([String].self, forKey: .keywords) ?? []
        
        super.init()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(contactName, forKey: .contactName)
        try container.encodeIfPresent(category, forKey: .category)
        try container.encodeIfPresent(subcategories, forKey: .subcategories)
        try container.encodeIfPresent(resourceDescription, forKey: .resourceDescription)
        try container.encodeIfPresent(address1, forKey: .address1)
        try container.encodeIfPresent(address2, forKey: .address2)
        try container.encodeIfPresent(city, forKey: .city)
        try container.encodeIfPresent(state, forKey: .state)
        try container.encodeIfPresent(zip, forKey: .zip)
        try container.encodeIfPresent(websiteUrl?.absoluteString, forKey: .websiteUrl)
        try container.encodeIfPresent(phoneNumber, forKey: .phoneNumber)
        try container.encodeIfPresent(counties, forKey: .counties)
        try container.encodeIfPresent(location?.latitude, forKey: .latitude)
        try container.encodeIfPresent(location?.longitude, forKey: .longitude)
        try container.encodeIfPresent(keywords, forKey: .keywords)
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
