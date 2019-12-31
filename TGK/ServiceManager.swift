//
//  AlamofireManager.swift
//  WufooPOC
//
//  Created by Jay Park on 4/7/18.
//  Copyright © 2018 ThoughtSeize. All rights reserved.
//

import Foundation
import Alamofire
import Combine

class ServiceManager: NSObject {
    
    static let wufooAPIKey = "NNAU-AZAS-13TW-IRUX:welcometotgk12345!"
    
    static let sharedInstace = ServiceManager()
    
    var sessionManager = SessionManager(configuration: .default)
    var sessionDelegate: Alamofire.SessionDelegate!
    
    enum ServiceError:Error {
        case badUrl
        case networking
        case parsing
    }
    
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
    
    //TODO Still experimenting with networking
    @available(iOS 13.0, *)
    func getData(url: URL, parameters:[String:Any]?) -> AnyPublisher<Data, ServiceError> {
        var urlRequest = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 20000)
        urlRequest.httpMethod = "GET"
        
        //TODO insert params
//        do {
//            let jsondata = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
//            urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//            urlRequest.httpBody = jsondata
//        }
//        catch {
//
//        }
        return self.requestData(urlRequest: urlRequest)
    }
    
//    @available(iOS 13.0, *)
//    func postData(url: URL) -> AnyPublisher<Data, ServiceError> {
//        var urlRequest = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 20000)
//        urlRequest.httpMethod = "POST"
//        return self.requestData(urlRequest: urlRequest)
//    }
    
    @available(iOS 13.0, *)
    func requestData(urlRequest: URLRequest) -> AnyPublisher<Data, ServiceError> {
        
        let urlsession = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        return urlsession.dataTaskPublisher(for: urlRequest).map { (response) -> Data in
            return response.data
        }.mapError { (URLerror) -> ServiceError in
            return ServiceError.parsing
        }.eraseToAnyPublisher()
    }
    
}

extension ServiceManager: URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodClientCertificate) {
            completionHandler(.rejectProtectionSpace, nil)
        }
        if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
            let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            completionHandler(.useCredential, credential)
        }
    }
}


