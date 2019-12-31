//
//  ServiceManager+SafetyNet.swift
//  TGK
//
//  Created by Jay Park on 8/28/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import Foundation
import Alamofire
import Combine

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
            
            completion(safetyNetModels, nil)
        }
    }
    
    @available (iOS 13.0, *)
    func getStabilityNetResourcesPublisher() -> AnyPublisher<[SafetyNetResourceModel], ServiceError> {
        
        return self.getData(url: Router.getSafetyNet.url, parameters: nil).tryMap { data -> [SafetyNetResourceModel] in
            guard let jsonResponse = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any],
                let safetyNetArray = jsonResponse["records"] as? [[String:Any]] else {
                    throw ServiceError.parsing
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
            }
            return safetyNetModels
            
        }.mapError { (error) -> ServiceError in
            switch error {
            case let fallThroughError as ServiceError:
                return fallThroughError
            default:
                return ServiceError.parsing
            }
            
        }.catch { error -> AnyPublisher<[SafetyNetResourceModel], ServiceError> in
            return Fail(error: ServiceError.parsing).eraseToAnyPublisher()
            
        }.eraseToAnyPublisher()
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
