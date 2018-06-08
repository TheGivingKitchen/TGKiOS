//
//  CalendarEventModel.swift
//  TGK
//
//  Created by Jay Park on 6/6/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import Foundation
import SwiftyXMLParser

struct RSSCalendarEventModel {
    let title:String
    let description:String
    let urlString:String?
    let imageUrlString:String?
    
    init(xmlItem: XML.Accessor) {
        self.title = xmlItem["title"].text ?? ""
        self.description = xmlItem["description"].text ?? ""
        self.urlString = xmlItem["link"].text
        self.imageUrlString = xmlItem["media:content"].attributes["url"]
    }
}
