//
//  FormPageModel.swift
//  TGK
//
//  Created by Jay Park on 5/6/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import Foundation

struct FormPagePageModel {
    let pageTitle:String
    let pageInformation:String
    let questions:[FormQuestionModel]
    
    
    init(jsonDict:[String:Any]) {
        self.pageTitle = jsonDict["pageTitle"] as? String ?? ""
        self.pageInformation = jsonDict["pageInformation"] as? String ?? ""
        let questionsArray = jsonDict["questions"] as? [[String:Any]] ?? [[String:Any]]()
        
        var questionModels = [FormQuestionModel]()
        for questionDict in questionsArray {
            let questionModel = FormQuestionModel(jsonDict: questionDict)
            questionModels.append(questionModel)
        }
        self.questions = questionModels
    }
}
