//
//  ServiceManager+Forms.swift
//  TGK
//
//  Created by Jay Park on 5/5/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import Foundation
import Alamofire

extension ServiceManager {
    
    fileprivate var wufooAuthenticationHeaders:[String:String] {
        let wufooAPIKey = "M7Q4-OZTA-MBXK-S2WT:welcometotgk12345"
        return ["Authorization":"Basic \(wufooAPIKey.base64String)"]
    }
    
    func getForm(id:String, completion:@escaping ([FormQuestionModel]?, Error?)->Void) {
        self.sessionManager.request(Router.getForm(id).url, encoding: JSONEncoding.default, headers: self.wufooAuthenticationHeaders).responseJSON { (response) in
            print(response)
            
            if let error = response.result.error {
                completion(nil, error)
            }
            
            guard let topLevelJsonDict = response.result.value as? [String:Any],
                let jsonArray = topLevelJsonDict["Fields"] as? [[String:Any]] else {
                    completion(nil, nil)
                    return
            }
            
            let filteredArray = jsonArray.filter({ (dict) -> Bool in
                //filtering out noise using a common question attribute. fragile
                return dict["IsRequired"] != nil ? true : false
            })
            
            var parsedModels = [FormQuestionModel]()
            for jsonDict in filteredArray {
                parsedModels.append(FormQuestionModel(jsonDict: jsonDict))
            }
            completion(parsedModels, nil)
        }
    }
    
    //MARK: - testing area
    func getAllWufooForms() {
        self.sessionManager.request(Router.getAllForms.url, encoding: JSONEncoding.default, headers: self.wufooAuthenticationHeaders).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(value)
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    func test(completion: @escaping (SegmentedFormModel?, Error?)->Void) {
        
        if let path = Bundle.main.path(forResource: "assistanceForm", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jsonObj = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String:Any]
                let segmentedForm = SegmentedFormModel(jsonDict: jsonObj)
                completion(segmentedForm, nil)
                
            }
            catch let error {
                print("parse error: \(error.localizedDescription)")
                completion(nil, nil)
            }
        }
        else {
            print("Invalid filename/path.")
            completion(nil, nil)
        }
    }
    
}
