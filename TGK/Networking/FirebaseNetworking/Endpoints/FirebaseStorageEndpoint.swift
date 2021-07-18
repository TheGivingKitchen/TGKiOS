//
//  FirebaseStorageEndpoint.swift
//  TGK
//
//  Created by Jay Park on 7/17/21.
//  Copyright © 2021 TheGivingKitchen. All rights reserved.
//

import Foundation

class FirebaseStorageEndpoint {
    internal let scheme:String = "https"
    internal let host:String = "firebasestorage.googleapis.com"
    
    internal var path:String?
    internal var percentEncodedPath:String?
    internal var queryItems:[URLQueryItem]?
}

extension FirebaseStorageEndpoint:Endpoint {
    var url: URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = self.scheme
        urlComponents.host = self.host
        if let path = self.path {
            urlComponents.path = path
        }
        if let percentEncodedPath = self.percentEncodedPath {
            urlComponents.percentEncodedPath = percentEncodedPath
        }
        urlComponents.queryItems = self.queryItems
        
        guard let url = urlComponents.url else {
            preconditionFailure("Invalid URL components: \(urlComponents)")
        }
        
        return url
    }
}
