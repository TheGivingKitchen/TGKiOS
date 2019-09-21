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
    @IBOutlet weak var gainesvilleLabel: UILabel!
    @IBOutlet weak var maconLabel: UILabel!
    @IBOutlet weak var coastalLabel: UILabel!
    @IBOutlet weak var athensLabel: UILabel!
    @IBOutlet weak var columbusLabel: UILabel!
    @IBOutlet weak var romeLabel: UILabel!
    @IBOutlet weak var bottomDividerView: UIView!
    @IBOutlet weak var stackViewRowTwo: UIStackView!
    @IBOutlet weak var stackViewRowThree: UIStackView!
    
    weak var delegate:FacebookGroupAccessTableViewCellDelegate?
    
    private let fbDeepLinkBaseString = "fb://group?id="
    private let fbGroupUrlBaseString = "https://www.facebook.com/groups/"
    
    private let fbMetroGroupId = "1426736404312089"
    private let fbNorthGroupId = "1836033839791219"
    private let fbSouthGroupId = "1763853010365060"
    private let fbGainesvilleGroupId = "897787080404359"
    private let fbMaconGroupId = "218626942273765"
    private let fbCoastalGroupId = "197473227547650"
    private let fbAthensGroupId = "187999045361005"
    private let fbColumbusGroupId = "186740988816183"
    private let fbRomeGroupId = "182229385767905"
    
    
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
        
        self.gainesvilleLabel.font = UIFont.tgkBody
        self.gainesvilleLabel.textColor = UIColor.tgkBlue
        
        self.maconLabel.font = UIFont.tgkBody
        self.maconLabel.textColor = UIColor.tgkBlue
        
        self.coastalLabel.font = UIFont.tgkBody
        self.coastalLabel.textColor = UIColor.tgkBlue
        
        self.athensLabel.font = UIFont.tgkBody
        self.athensLabel.textColor = UIColor.tgkBlue
        
        self.columbusLabel.font = UIFont.tgkBody
        self.columbusLabel.textColor = UIColor.tgkBlue
        
        self.romeLabel.font = UIFont.tgkBody
        self.romeLabel.textColor = UIColor.tgkBlue
        
        self.bottomDividerView.backgroundColor = UIColor.tgkBackgroundGray
    }
    
    fileprivate func open(groupId:String, analyticsName:String) {
        
        guard let deepLinkUrl = URL(string: self.fbDeepLinkBaseString + groupId),
            let webUrl = URL(string: self.fbGroupUrlBaseString + groupId) else {
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
        self.open(groupId: self.fbMetroGroupId, analyticsName: "metro_atlanta")
    }
    
    @IBAction func northGroupPressed(_ sender: Any) {
        self.open(groupId: self.fbNorthGroupId, analyticsName: "north_ga")
    }
    
    @IBAction func southGroupPressed(_ sender: Any) {
        self.open(groupId: self.fbSouthGroupId, analyticsName: "south_ga")
    }
    @IBAction func gainesvilleGroupPressed(_ sender: Any) {
        self.open(groupId: self.fbGainesvilleGroupId, analyticsName: "gainesville_ga")
    }
    @IBAction func maconGroupPressed(_ sender: Any) {
        self.open(groupId: self.fbMaconGroupId, analyticsName: "macon_ga")
    }
    @IBAction func coastalGroupPressed(_ sender: Any) {
        self.open(groupId: self.fbCoastalGroupId, analyticsName: "coastal_ga")
    }
    @IBAction func athensGroupPressed(_ sender: Any) {
        self.open(groupId: self.fbAthensGroupId, analyticsName: "athens_ga")
    }
    @IBAction func columbusGroupPressed(_ sender: Any) {
        self.open(groupId: self.fbColumbusGroupId, analyticsName: "columbus_ga")
    }
    @IBAction func romeGroupPressed(_ sender: Any) {
        self.open(groupId: self.fbRomeGroupId, analyticsName: "rome_ga")
    }
}
