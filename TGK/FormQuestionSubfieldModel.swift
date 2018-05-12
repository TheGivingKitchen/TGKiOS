//
//  FormQuestionSubfieldModel.swift
//  TGK
//
//  Created by Jay Park on 5/12/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import Foundation

struct FormQuestionSubfieldModel {
    var id:String
    var label:String
    var defaultValue:String?
    
    init(jsonDict:[String:Any]) {
        self.id = jsonDict["ID"] as? String ?? ""
        self.label = jsonDict["Label"] as? String ?? ""
        self.defaultValue = jsonDict["DefaultVal"] as? String
    }
}
