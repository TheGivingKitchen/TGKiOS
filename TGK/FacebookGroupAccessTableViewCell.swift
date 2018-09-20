//
//  FacebookGroupAccessTableViewCell.swift
//  TGK
//
//  Created by Jay Park on 9/2/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import UIKit
import Firebase

protocol FacebookGroupAccessTableViewCellDelegate:class {
    func facebookGroupAccessTableViewCellRequestOpen(url: URL)
}

class FacebookGroupAccessTableViewCell: UITableViewCell {

    @IBOutlet weak var joinUsLabel: UILabel!
    @IBOutlet weak var metroAtlLabel: UILabel!
    @IBOutlet weak var northGaLabel: UILabel!
    @IBOutlet weak var southGaLabel: UILabel!
    @IBOutlet weak var bottomDividerView: UIView!
    
    weak var delegate:FacebookGroupAccessTableViewCellDelegate?
    
    private let metroGroupDeepLinkString = "fb://group?id=1426736404312089"
    private let metroGroupUrlString = "https://www.facebook.com/groups/1426736404312089"
    
    private let northGroupDeepLinkString = "fb://group?id=1836033839791219"
    private let northGroupUrlString = "https://www.facebook.com/groups/1836033839791219"
    
    private let southGroupDeepLinkString = "fb://group?id=1763853010365060"
    private let southGroupUrlString = "https://www.facebook.com/groups/1763853010365060"
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.styleView()
    }
    
    private func styleView() {
        self.joinUsLabel.font = UIFont.tgkBody
        self.joinUsLabel.textColor = UIColor.tgkGray
        
        self.metroAtlLabel.font = UIFont.tgkBody
        self.metroAtlLabel.textColor = UIColor.tgkBlue
        
        self.northGaLabel.font = UIFont.tgkBody
        self.northGaLabel.textColor = UIColor.tgkBlue
        
        self.southGaLabel.font = UIFont.tgkBody
        self.southGaLabel.textColor = UIColor.tgkBlue
        
        self.bottomDividerView.backgroundColor = UIColor.tgkBackgroundGray
    }

    //MARK: Facebook group button actions
    @IBAction func metroGroupPressed(_ sender: Any) {
        guard let deepLinkUrl = URL(string: self.metroGroupDeepLinkString),
            let webUrl = URL(string: self.metroGroupUrlString) else {
                return
        }
        
        UIApplication.shared.open(deepLinkUrl, options: [:]) { (success) in
            if success == false {
                self.delegate?.facebookGroupAccessTableViewCellRequestOpen(url: webUrl)
            }
        }
        
        Analytics.logEvent(customName: .safetyNetFacebookGroupVisit, parameters: [.safetyNetFacebookGroupName:"metro_atlanta"])
    }
    
    @IBAction func northGroupPressed(_ sender: Any) {
        guard let deepLinkUrl = URL(string: self.northGroupDeepLinkString),
            let webUrl = URL(string: self.northGroupUrlString) else {
                return
        }
        
        UIApplication.shared.open(deepLinkUrl, options: [:]) { (success) in
            if success == false {
                self.delegate?.facebookGroupAccessTableViewCellRequestOpen(url: webUrl)
            }
        }
        
        Analytics.logEvent(customName: .safetyNetFacebookGroupVisit, parameters: [.safetyNetFacebookGroupName:"north_ga"])
    }
    
    @IBAction func southGroupPressed(_ sender: Any) {
        guard let deepLinkUrl = URL(string: self.southGroupDeepLinkString),
            let webUrl = URL(string: self.southGroupUrlString) else {
                return
        }
        
        UIApplication.shared.open(deepLinkUrl, options: [:]) { (success) in
            if success == false {
                self.delegate?.facebookGroupAccessTableViewCellRequestOpen(url: webUrl)
            }
        }
        
        Analytics.logEvent(customName: .safetyNetFacebookGroupVisit, parameters: [.safetyNetFacebookGroupName:"south_ga"])
    }
}
