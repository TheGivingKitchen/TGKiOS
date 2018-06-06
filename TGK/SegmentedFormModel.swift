//
//  SegmentedFormModel.swift
//  WufooPOC
//
//  Created by Jay Park on 4/18/18.
//  Copyright © 2018 ThoughtSeize. All rights reserved.
//

import Foundation

struct SegmentedFormModel {
    
    let id:String
    let title:String
    let subtitle:String
    let metadata:String
    let pages:[FormPagePageModel]
    let defaultAnswers:[FormQuestionAnswerModel]
    
    var shareFormUrlString:String {
        return "https://thegivingkitchen.wufoo.com/forms/\(self.id)"
    }
    
    init(jsonDict:[String:Any]) {
        self.id = jsonDict["ID"] as? String ?? ""
        self.title = jsonDict["FormTitle"] as? String ?? ""
        self.subtitle = jsonDict["FormSubtitle"] as? String ?? ""
        self.metadata = jsonDict["FormMetadata"] as? String ?? ""
        
        
        var parsedDefaultAnswers = [FormQuestionAnswerModel]()
        if let defaultAnswersArray = jsonDict["DefaultAnswers"] as? [[String:String]] {
            for answerDict in defaultAnswersArray {
                guard let answerId = answerDict["ID"],
                    let answerValue = answerDict["Answer"] else {
                        continue
                }
                let parsedAnswerModel = FormQuestionAnswerModel(wufooFieldID: answerId, userAnswer: answerValue)
                parsedDefaultAnswers.append(parsedAnswerModel)
            }
        }
        self.defaultAnswers = parsedDefaultAnswers
        
        //pagesArray is a 2D array. each element in the top level contains a
        guard let pagesArray = jsonDict["Pages"] as? [[String:Any]] else {
            self.pages = [FormPagePageModel]()
            return
        }
        
        var parsedPagesArray = [FormPagePageModel]()
        for pageDict in pagesArray {
            let page = FormPagePageModel(jsonDict: pageDict)
            parsedPagesArray.append(page)
        }
        self.pages = parsedPagesArray
    }
}

