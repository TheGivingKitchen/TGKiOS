//
//  AlamofireManager.swift
//  WufooPOC
//
//  Created by Jay Park on 4/7/18.
//  Copyright © 2018 ThoughtSeize. All rights reserved.
//

import Foundation
import Alamofire


class ServiceManager: NSObject {
    
    static let wufooAPIKey = "NNAU-AZAS-13TW-IRUX:welcometotgk12345!"
    
    static let sharedInstace = ServiceManager()
    
    var sessionManager = SessionManager(configuration: .default)
    var sessionDelegate: Alamofire.SessionDelegate!
    
    override init() {
        super.init()
        
        self.sessionDelegate = sessionManager.delegate
        self.sessionDelegate.sessionDidReceiveChallengeWithCompletion = { (session, challenge, completionHandler) in
            if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodClientCertificate) {
                completionHandler(.rejectProtectionSpace, nil)
            }
            if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
                let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
                completionHandler(.useCredential, credential)
            }
        }
    }
    
    
    //TODO change to local segmented form and take a string param in
    func getSegmentedForm(completion: @escaping (SegmentedFormModel?, Error?)->Void) {
        
        if let path = Bundle.main.path(forResource: "segmentedForm", ofType: "json") {
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


