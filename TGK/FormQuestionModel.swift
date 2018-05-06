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
        case unknown = "unknown"
        case textField = "text"
        case number = "number"
        case radio = "radio"
        case select = "select"
        case listSingleSelect = "listSingleSelect"
        case textView = "textarea"
        case phoneNumber = "phone"
    }
    
    let id:String
    let questionTitle:String
    let instructions:String
    let answerOptions:[String]
    let questionType:QuestionType
    let isRequired:Bool
    

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
        
        self.isRequired = jsonDict["IsRequired"] as? Bool ?? false
        
        var parsedOptions = [String]()
        if let optionArray = jsonDict["Choices"] as? [[String:String]] {
            
            for optionDict in optionArray {
                if let option = optionDict["Label"] {
                    parsedOptions.append(option)
                }
            }
        }
        self.answerOptions = parsedOptions
    }
}
