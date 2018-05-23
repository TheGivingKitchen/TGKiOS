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
    let pages:[FormPagePageModel]
    
    var shareFormUrlString:String {
        return "https://thegivingkitchen.wufoo.com/forms/\(self.id)"
    }
    
    init(jsonDict:[String:Any]) {
        self.id = jsonDict["ID"] as? String ?? ""
        
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

