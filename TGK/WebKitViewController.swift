//
//  WebKitViewController.swift
//  TGK
//
//  Created by Jay Park on 12/24/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import UIKit
import WebKit

class WebKitViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    var urlRequest:URLRequest? {
        didSet {
            guard self.isViewLoaded else {
                return
            }
            if let request = self.urlRequest {
                self.webView.load(request)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let request = self.urlRequest {
            self.webView.load(request)
        }
    }
}

//MARK: convenience initializer
extension WebKitViewController {
    static func webKitViewControllerWithNavigationController(request:URLRequest?) -> UINavigationController {
        let webkitVC = UIStoryboard(name: "Utilities", bundle: nil).instantiateViewController(withIdentifier: "WebKitViewControllerId") as! WebKitViewController
        let navVC = UINavigationController(rootViewController: webkitVC)
        navVC.navigationBar.barTintColor = UIColor.tgkBlue
        navVC.navigationBar.tintColor = UIColor.tgkOrange
        return navVC
    }
}
