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
    
    private let deepLinkBaseString = "fb://group?id="
    private let groupUrlBaseString = "https://www.facebook.com/groups/"
    
    private let metroGroupId = "1426736404312089"
    private let northGroupId = "1836033839791219"
    private let southGroupId = "1763853010365060"
    private let gainesvilleGroupId = "897787080404359"
    private let maconGroupId = "218626942273765"
    private let coastalGroupId = "197473227547650"
    private let athensGroupId = "187999045361005"
    private let columbusGroupId = "186740988816183"
    private let romeGroupId = "182229385767905"
    
    
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
    
    fileprivate func open(groupId:String, analyticsName:String) {
        
        guard let deepLinkUrl = URL(string: self.deepLinkBaseString + groupId),
            let webUrl = URL(string: self.groupUrlBaseString + groupId) else {
                return
        }
        
        if UIApplication.shared.canOpenURL(deepLinkUrl) {
            UIApplication.shared.open(deepLinkUrl, options: [:]) { (success) in
            }
        }
        else {
            self.delegate?.facebookGroupAccessTableViewCellRequestOpen(url: webUrl)
        }
        
        Analytics.logEvent(customName: .safetyNetFacebookGroupVisit, parameters: [.safetyNetFacebookGroupName:analyticsName])
    }

    //MARK: Facebook group button actions
    @IBAction func metroGroupPressed(_ sender: Any) {
        self.open(groupId: self.metroGroupId, analyticsName: "metro_atlanta")
    }
    
    @IBAction func northGroupPressed(_ sender: Any) {
        self.open(groupId: self.northGroupId, analyticsName: "north_ga")
    }
    
    @IBAction func southGroupPressed(_ sender: Any) {
        self.open(groupId: self.southGroupId, analyticsName: "south_ga")
    }
    @IBAction func gainesvilleGroupPressed(_ sender: Any) {
        self.open(groupId: self.gainesvilleGroupId, analyticsName: "gainesville_ga")
    }
    @IBAction func maconGroupPressed(_ sender: Any) {
        self.open(groupId: self.maconGroupId, analyticsName: "macon_ga")
    }
    @IBAction func coastalGroupPressed(_ sender: Any) {
        self.open(groupId: self.coastalGroupId, analyticsName: "coastal_ga")
    }
    @IBAction func athensGroupPressed(_ sender: Any) {
        self.open(groupId: self.athensGroupId, analyticsName: "athens_ga")
    }
    @IBAction func columbusGroupPressed(_ sender: Any) {
        self.open(groupId: self.columbusGroupId, analyticsName: "columbus_ga")
    }
    @IBAction func romeGroupPressed(_ sender: Any) {
        self.open(groupId: self.romeGroupId, analyticsName: "rome_ga")
    }
}
