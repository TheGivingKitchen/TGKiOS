//
//  StabilityNetDTO.swift
//  TGK
//
//  Created by Jay Park on 7/16/21.
//  Copyright © 2021 TheGivingKitchen. All rights reserved.
//

import Foundation

public struct StabilityNetResourceDTO:Codable {
    var id:String
    var fields:fields
    
    public struct fields:Codable {
        var name:String?
        var address1:String?
        var address2:String?
        var city:String?
        var state:String?
        var zip:String?
        var website:String?
        var phone:String?
        var contactName:String?
        var category:String?
        var subcategories:[String]?
        var description:String?
        var countiesServed:[String]?
        var latitude:Double?
        var longitude:Double?
        var keywords:[String]?
        var isStatewide:Bool?
        var isNationwide:Bool?
    }
    
    
}
