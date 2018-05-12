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
    
    func submitAnswersToForm(_ formId:String, withAnswers answers:[FormQuestionAnswerModel], completion:@escaping (Bool, Error?, [FormFieldErrorModel]?) -> Void) {
        
        let postFormRoute = Router.postFormEntry(formId)
        self.sessionManager.request(postFormRoute.url, method: postFormRoute.httpMethod, parameters: FormQuestionAnswerModel.convertToAnswerDictionary(answers), encoding: URLEncoding.default, headers: self.wufooAuthenticationHeaders).responseJSON { (response) in
            
            //Wufoo is insane and returns a success result with a value "success = 0" for failures
            guard response.result.error == nil else {
                completion(false, response.result.error, nil)
                return
            }
            
            guard let responseJson = response.result.value as? [String:Any],
                let success = responseJson["Success"] as? Bool else {
                completion(false, NSError(domain: "", code: 999, userInfo: [NSLocalizedDescriptionKey:"Parsing error"]), nil)
                return
            }
            
            //Success case
            guard success == false else {
                completion(success, nil, nil)
                return
            }
            
            //Failure case. Parse errors into models
            guard let fieldErrors = responseJson["FieldErrors"] as? [[String:String]] else {
                completion(false, NSError(domain: "", code: 999, userInfo: [NSLocalizedDescriptionKey:"Parsing error"]), nil)
                return
            }
            
            var parsedErrors = [FormFieldErrorModel]()
            for fieldError in fieldErrors {
                let errorModel = FormFieldErrorModel(wufooFieldId: fieldError["ID"] ?? "", errorText: fieldError["ErrorText"] ?? "")
                parsedErrors.append(errorModel)
            }
            completion(false, NSError(domain: "", code: 999, userInfo: [NSLocalizedDescriptionKey:"Form field submission error"]), parsedErrors)
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
    
    func getTestSegmentedForm(id:String, completion: @escaping (SegmentedFormModel?, Error?)->Void) {
        //assistance inquiry
        if id == "zl0n8dd0u0hk0z" {
            if let path = Bundle.main.path(forResource: "assistanceInquiry", ofType: "json") {
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
        else if id == "z1a0tap91any17q" {
            if let path = Bundle.main.path(forResource: "volunteerSignup", ofType: "json") {
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
    
}
