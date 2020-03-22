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
            let safetyNetArray = topLevelJsonDict["records"] as? [[String:Any]] else {
                completion(nil, NSError(domain: "", code: 999, userInfo: [NSLocalizedDescriptionKey:"Parsing error"]))
                return
            }
            
            var safetyNetModels = [SafetyNetResourceModel]()
            for record in safetyNetArray {
                do {
                    if let innerFieldDictionary = record["fields"] {
                        let jsonData = try JSONSerialization.data(withJSONObject: innerFieldDictionary, options: .prettyPrinted)
                        let safetyNetModel = try JSONDecoder().decode(SafetyNetResourceModel.self, from: jsonData)
                        safetyNetModels.append(safetyNetModel)
                    }
                }
                catch {
                    //throw the record out
                }
            }
            
            var allDicts = [[String:Any]]()
            
            for model in safetyNetModels {
                var dict = [String:Any]()
                dict["name"] = model.name
                dict["address"] = model.address ?? ""
                dict["website"] = model.websiteUrl?.absoluteString ?? ""
                dict["phone"] = model.phoneNumber ?? ""
                dict["contactName"] = model.contactName ?? ""
                dict["category"] = model.category
                dict["description"] = model.resourceDescription
                dict["countiesServed"] = model.counties?.joined(separator: ",")
                if let lat = model.location?.latitude,
                    let long = model.location?.longitude {
                    dict["latitude"] = lat
                    dict["longitude"] = long
                }
                
                allDicts.append(dict)
            }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: allDicts, options:.prettyPrinted)
                let jsonstring = String(data: jsonData, encoding: String.Encoding.utf8) as! NSString ?? ""
                print(jsonstring as String)
                
                completion(safetyNetModels, nil)
            }
            catch {
            
            }
            
        }
    }
    
    //Testing
//    func getLocalSafetyNetResources(completion:@escaping ([SafetyNetResourceModel]?, Error?)->Void) {
//        if let path = Bundle.main.path(forResource: "safetyNet", ofType: "json") {
//            do {
//                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
//                let jsonObj = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String:Any]
//                let safetyNetArray = jsonObj["safetyNet"] as! [[String:Any]]
//                
//                let jsonData = try JSONSerialization.data(withJSONObject: safetyNetArray, options: .prettyPrinted)
//                
//                let models = try JSONDecoder().decode([SafetyNetResourceModel].self, from: jsonData)
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
