//
//  ServiceManager+Events.swift
//  TGK
//
//  Created by Jay Park on 6/7/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyXMLParser
import Combine

extension ServiceManager {
    func getEventFeed(completion: @escaping ([RSSCalendarEventModel]?, Error?) -> Void) {
        self.sessionManager.request(Router.getEventFeed.url, parameters: ["format":"rss"], encoding: URLEncoding.default).responseData { (response) in
            
            guard response.error == nil else {
                completion(nil, response.error)
                return
            }

            var parsedEventModels = [RSSCalendarEventModel]()
            if let data = response.data {
                let xml = XML.parse(data)
                let xmlChannelItems = xml["rss"]["channel"]["item"]
                
                for xmlItem in xmlChannelItems {
                    let parsedEventModel = RSSCalendarEventModel(xmlItem: xmlItem)
                    parsedEventModels.append(parsedEventModel)
                }
            }
            completion(parsedEventModels, response.error)
        }
    }
    
    @available(iOS 13.0, *)
    func getEventFeedPublisher() -> AnyPublisher<[RSSCalendarEventModel], ServiceError> {
        //LOOK the format:rss parameters arent getting encoded properly. http header? how does this affect the base getData call?
        return self.getData(url: Router.getEventFeed.url, parameters: ["format":"rss"]).map { (data) -> [RSSCalendarEventModel] in
            var parsedEventModels = [RSSCalendarEventModel]()
            let xml = XML.parse(data)
            let xmlChannelItems = xml["rss"]["channel"]["item"]
            
            for xmlItem in xmlChannelItems {
                let parsedEventModel = RSSCalendarEventModel(xmlItem: xmlItem)
                parsedEventModels.append(parsedEventModel)
            }
            
            return parsedEventModels
        }.mapError { (ServiceError) -> ServiceError in
            return ServiceManager.ServiceError.parsing
        }.eraseToAnyPublisher()
    }
}
