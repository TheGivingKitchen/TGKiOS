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
    let pages:[Page]
    
    init(jsonDict:[String:Any]) {
        self.id = jsonDict["ID"] as? String ?? ""
        
        //pagesArray is a 2D array. each element in the top level contains a
        guard let pagesArray = jsonDict["Pages"] as? [[String:Any]] else {
            self.pages = [Page]()
            return
        }
        
        var parsedPagesArray = [Page]()
        for pageDict in pagesArray {
            let page = Page(jsonDict: pageDict)
            parsedPagesArray.append(page)
        }
        self.pages = parsedPagesArray
    }
    
    struct Page {
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
    
}

