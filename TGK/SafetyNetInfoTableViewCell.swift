//
//  SafetyNetInfoTableViewCell.swift
//  TGK
//
//  Created by Jay Park on 8/29/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import UIKit

protocol SafetyNetInfoTableViewCellDelegate:class {
    func safetyNetInfoTableViewCellRequestOpenWeb(url:URL, cell:SafetyNetInfoTableViewCell)
    func safetyNetInfoTableViewCellRequestCallPhone(url:URL, cell:SafetyNetInfoTableViewCell)
    //TODO address callback
}

class SafetyNetInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var websiteButton: UIButton!
    @IBOutlet weak var addressButton: UIButton!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var countiesLabel: UILabel!
    
    weak var delegate:SafetyNetInfoTableViewCellDelegate?
    var safetyNetModel:SafetyNetResourceModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.styleView()
    }
    
    func styleView() {
        self.nameLabel.font = UIFont.tgkSubtitle
        self.nameLabel.textColor = UIColor.tgkOrange
        
        self.categoryLabel.font = UIFont.tgkNavigation
        self.categoryLabel.textColor = UIColor.tgkBlue
        
        self.websiteButton.titleLabel?.font = UIFont.tgkBody
        self.websiteButton.tintColor = UIColor.tgkBlue
        
        self.addressButton.titleLabel?.font = UIFont.tgkBody
        self.addressButton.tintColor = UIColor.tgkBlue
        
        self.phoneButton.titleLabel?.font = UIFont.tgkBody
        self.phoneButton.tintColor = UIColor.tgkBlue
        
        self.contactNameLabel.font = UIFont.tgkBody
        self.contactNameLabel.textColor = UIColor.tgkDarkDarkGray
        
        self.descriptionLabel.font = UIFont.tgkBody
        self.descriptionLabel.textColor = UIColor.tgkDarkDarkGray
        
        self.countiesLabel.font = UIFont.tgkBody
        self.countiesLabel.textColor = UIColor.tgkDarkDarkGray
    }
    
    func configure(withSafetyNetModel model:SafetyNetResourceModel) {
        self.safetyNetModel = model
        
        self.nameLabel.text = model.name
        
        if model.category.isNilOrEmpty {
            self.categoryLabel.isHidden = true
        }
        else {
            self.categoryLabel.text = model.category
        }
        
        if let urlString = model.websiteUrlString,
            let _ = URL(string: urlString) {
            self.websiteButton.isHidden = true
        }
        else {
            self.websiteButton.setTitle("Go to website", for: .normal)
        }
        
        if model.address.isNilOrEmpty {
            self.addressButton.isHidden = true
        }
        else {
            self.addressButton.setTitle(model.address, for: .normal)
        }
        
        if model.phoneNumber.isNilOrEmpty {
            self.phoneButton.isHidden = true
        }
        else {
            self.phoneButton.setTitle(model.phoneNumber, for: .normal)
        }
        
        if model.contactName.isNilOrEmpty {
            self.contactNameLabel.isHidden = true
        }
        else {
            self.contactNameLabel.text = model.contactName
        }
        
        if model.resourceDescription.isNilOrEmpty {
            self.descriptionLabel.isHidden = true
        }
        else {
            self.descriptionLabel.text = model.resourceDescription
        }
        
        if let counties = model.counties,
            counties.count > 0 {
            let joinedCounties = counties.joined(separator: ", ")
            self.countiesLabel.text = "Serving counties: \(joinedCounties)"
        }
        else {
            self.countiesLabel.isHidden = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func websiteButtonPressed(_ sender: Any) {
        if let model = self.safetyNetModel,
            let urlString = model.websiteUrlString,
            let url = URL(string: urlString) {
            self.delegate?.safetyNetInfoTableViewCellRequestOpenWeb(url: url, cell: self)
        }
    }
    
    @IBAction func addressButtonPressed(_ sender: Any) {
        //TODO open in maps and google maps
    }
    
    @IBAction func phoneButtonPressed(_ sender: Any) {
        if let phoneNumber = self.safetyNetModel?.phoneNumber,
            let phoneUrl = URL(string: "tel://\(phoneNumber)") {
            self.delegate?.safetyNetInfoTableViewCellRequestCallPhone(url: phoneUrl, cell: self)
        }
    }
    
    override func prepareForReuse() {
        self.categoryLabel.isHidden = false
        self.websiteButton.isHidden = false
        self.addressButton.isHidden = false
        self.phoneButton.isHidden = false
        self.contactNameLabel.isHidden = false
        self.descriptionLabel.isHidden = false
        self.countiesLabel.isHidden = false
    }

}
