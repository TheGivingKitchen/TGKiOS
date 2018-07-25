//
//  ExternalShareManager.swift
//  TGK
//
//  Created by Jay Park on 5/28/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import Foundation
import UIKit

import UIKit

class ExternalShareManager: NSObject {
    
    static let sharedInstance = ExternalShareManager()
    
    func presentShareControllerFromViewController(fromController:UIViewController, title:String, urlString:String?, image:UIImage?) {
        
        
        var activityItems:[Any] = [title]
        if let urlString = urlString,
            let url = URL(string: urlString) {
            activityItems.append(url)
        }
        if let image = image {
            activityItems.append(image)
        }
        
        let activityController = UIActivityViewController.init(activityItems: activityItems, applicationActivities: nil)
        activityController.excludedActivityTypes = [
            .addToReadingList,
            .assignToContact,
            .print
        ]
        activityController.completionWithItemsHandler = {
            (activityType, completed, returnedItems, activityError) in
            if completed {
                //TODO log analytics
            }
        }
        
        fromController.present(activityController, animated: true)
    }
}
