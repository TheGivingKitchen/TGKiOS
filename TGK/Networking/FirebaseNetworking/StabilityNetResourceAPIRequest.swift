//
//  StabilityNetResourceRequest.swift
//  TGK
//
//  Created by Jay Park on 7/9/21.
//  Copyright © 2021 TheGivingKitchen. All rights reserved.
//

import Foundation

class StabilityNetResourceAPIRequest:APIRequest {
    var endpoint: Endpoint
    
    init() {
        self.endpoint = StabilityNetEndpoint()
    }
    
    func constructRequest() -> URLRequest {
        var urlRequest = URLRequest(url: endpoint.url)
        urlRequest.httpMethod = "GET"
        return urlRequest
    }
}
