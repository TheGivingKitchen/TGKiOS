//
//  FormQuestionAnswer.swift
//  WufooPOC
//
//  Created by Jay Park on 4/19/18.
//  Copyright © 2018 ThoughtSeize. All rights reserved.
//

import UIKit

struct FormQuestionAnswerModel {
    let wufooFieldID:String
    let userAnswer:String?
    
    static func convertToAnswerDictionary(_ models:[FormQuestionAnswerModel]) -> [String:String] {
        var dict = [String:String]()
        for answerModel in models {
            dict[answerModel.wufooFieldID] = answerModel.userAnswer
        }
        return dict
    }
}
