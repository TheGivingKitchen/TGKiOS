//
//  FormQuestionModel.swift
//  WufooPOC
//
//  Created by Jay Park on 4/7/18.
//  Copyright © 2018 ThoughtSeize. All rights reserved.
//

import Foundation

struct FormQuestionModel {
    enum QuestionType:String {
        //standard wufoo components
        case unknown = "unknown"
        case textField = "text"
        case number = "number"
        case radio = "radio"
        case select = "select"
        case textView = "textarea"
        case email = "email"
        case phoneNumber = "phone"
        case shortName = "shortname"
        case address = "address"
        case date = "date"
        case checkbox = "checkbox"
    }
    
    let id:String
    let questionTitle:String
    let instructions:String
    let answerOptions:[String]
    let questionType:QuestionType
    let isRequired:Bool
    let hasOtherField:Bool
    let subfields:[FormQuestionSubfieldModel]

    init(jsonDict:[String:Any]) {
        self.id = jsonDict["ID"] as? String ?? ""
        self.questionTitle = jsonDict["Title"] as? String ?? ""
        self.instructions = jsonDict["Instructions"] as? String ?? ""
        if let typeString = jsonDict["Type"] as? String,
            let convertedType = QuestionType(rawValue: typeString) {
            self.questionType = convertedType
        }
        else {
            self.questionType = .unknown
        }
        
        if let isRequiredString = jsonDict["IsRequired"] as? String {
            self.isRequired = isRequiredString == "1" ? true : false
        }
        else {
            self.isRequired = false
        }
        
        self.hasOtherField = jsonDict["HasOtherField"] as? Bool ?? false
        
        var parsedOptions = [String]()
        if let optionArray = jsonDict["Choices"] as? [[String:String]] {
            
            for optionDict in optionArray {
                if let option = optionDict["Label"] {
                    parsedOptions.append(option)
                }
            }
        }
        self.answerOptions = parsedOptions
        
        var parsedSubfields = [FormQuestionSubfieldModel]()
        if let subfieldArray = jsonDict["SubFields"] as? [[String:String]] {
            for subfieldDict in subfieldArray {
                let subfieldModel = FormQuestionSubfieldModel(jsonDict: subfieldDict)
                parsedSubfields.append(subfieldModel)
            }
        }
        self.subfields = parsedSubfields
    }
}
