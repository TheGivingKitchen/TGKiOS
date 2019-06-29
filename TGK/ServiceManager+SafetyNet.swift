//
//  ServiceManager+SafetyNet.swift
//  TGK
//
//  Created by Jay Park on 8/28/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import Foundation
import Alamofire

extension ServiceManager {

    func getSafetyNetResources(completion:@escaping ([SafetyNetResourceModel]?, Error?)->Void) {
        self.sessionManager.request(Router.getSafetyNet.url, encoding: URLEncoding.default, headers:nil).responseJSON { (response) in

            if let error = response.result.error {
                completion(nil, error)
                return
            }
        
            guard let topLevelJsonDict = response.result.value as? [String:Any],
            let safetyNetArray = topLevelJsonDict["safetyNet"] as? [[String:Any]] else {
                completion(nil, NSError(domain: "", code: 999, userInfo: [NSLocalizedDescriptionKey:"Parsing error"]))
                return
            }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: safetyNetArray, options: .prettyPrinted)
                
                let models = try JSONDecoder().decode([SafetyNetResourceModel].self, from: jsonData)
                //            let models = SafetyNetResourceModel.modelsWithJsonArray(jsonArray: safetyNetArray)
                completion(models, nil)
            }
            catch {
                completion(nil, NSError(domain: "", code: 999, userInfo: [NSLocalizedDescriptionKey:"Parsing error"]))
            }

            
        }
    }
    
    //Testing
//    func getLocalSafetyNetResources(completion:@escaping ([SafetyNetResourceModel]?, Error?)->Void) {
//        if let path = Bundle.main.path(forResource: "safetyNet", ofType: "json") {
//            do {
//                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
//                let jsonObj = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String:Any]
//                
//                let safetyNetArray = jsonObj["safetyNet"] as! [[String:Any]]
//                
//                let models = SafetyNetResourceModel.modelsWithJsonArray(jsonArray: safetyNetArray)
//                completion(models, nil)
//                
//            }
//            catch let error {
//                print("parse error: \(error.localizedDescription)")
//                completion(nil, nil)
//            }
//        }
//        else {
//            print("Invalid filename/path.")
//            completion(nil, nil)
//        }
//    }
}
