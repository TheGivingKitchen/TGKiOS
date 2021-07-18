//
//  StabilityNetEndpoint.swift
//  TGK
//
//  Created by Jay Park on 7/9/21.
//  Copyright © 2021 TheGivingKitchen. All rights reserved.
//

import Foundation

class StabilityNetEndpoint:FirebaseStorageEndpoint {
    private let stabilityNetJsonFilePath = "/v0/b/thegivingkitchen-cdd28.appspot.com/o/stabilityNet%2FstabilityNet.json"
    private let requiredFirebaseStorageQueryItems = [URLQueryItem(name: "alt", value: "media")]
    
    override init() {
        super.init()
        self.percentEncodedPath = self.stabilityNetJsonFilePath
        self.queryItems = self.requiredFirebaseStorageQueryItems
    }
    
}
