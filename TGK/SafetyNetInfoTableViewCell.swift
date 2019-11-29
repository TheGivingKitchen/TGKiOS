//
//  SafetyNetInfoTableViewCell.swift
//  TGK
//
//  Created by Jay Park on 8/29/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import UIKit
import Firebase

class SafetyNetInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var subcategoryLabel: UILabel!
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var countiesLabel: UILabel!
    @IBOutlet weak var bottomDividerView: UIView!
    
    var safetyNetModel:SafetyNetResourceModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        self.styleView()
    }
    
    func styleView() {
        self.nameLabel.font = UIFont.tgkSubtitle
        self.nameLabel.textColor = UIColor.tgkBlue
        
        self.categoryLabel.font = UIFont.tgkNavigation
        self.categoryLabel.textColor = UIColor.tgkOrange
        
        self.subcategoryLabel.font = UIFont.tgkMetadata
        self.subcategoryLabel.textColor = UIColor.tgkGray
        
        self.contactNameLabel.font = UIFont.tgkBody
        self.contactNameLabel.textColor = UIColor.tgkDarkDarkGray
        
        self.descriptionLabel.font = UIFont.tgkBody
        self.descriptionLabel.textColor = UIColor.tgkDarkDarkGray
        
        self.countiesLabel.font = UIFont.tgkBody
        self.countiesLabel.textColor = UIColor.tgkGray
        
        self.bottomDividerView.backgroundColor = UIColor.tgkBackgroundGray
    }
    
    func configure(withSafetyNetModel model:SafetyNetResourceModel) {
        self.safetyNetModel = model
        
        self.nameLabel.text = model.name
        
        if model.category.isEmpty {
            self.categoryLabel.isHidden = true
        }
        else {
            self.categoryLabel.text = model.category
        }
        
        if model.subcategories.count == 0 {
            self.subcategoryLabel.isHidden = true
        }
        else if model.subcategories.count < 3 {
            self.subcategoryLabel.text = model.subcategories.joined(separator: " & ")
        }
        else {
            self.subcategoryLabel.text = "\(model.subcategories[0]), \(model.subcategories[1]) & more"
        }
        
        if model.contactName.isNilOrEmpty {
            self.contactNameLabel.isHidden = true
        }
        else {
            self.contactNameLabel.text = "Ask for: \(model.contactName ?? "Anyone")"
        }
        
        if model.resourceDescription.isNilOrEmpty {
            self.descriptionLabel.isHidden = true
        }
        else {
            self.descriptionLabel.text = model.resourceDescription
        }
        
        if model.isNationwide {
            self.countiesLabel.text = "This is a nationwide resource"
        }
        else if model.isStatewide,
            let state = model.state {
            self.countiesLabel.text = "Serves all of \(state)"
        }
        else if let counties = model.counties,
            counties.count > 0 {
            let joinedCounties = counties.joined(separator: ", ")
            self.countiesLabel.text = "Serves: \(joinedCounties)"
        }
        else {
            self.countiesLabel.isHidden = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        self.categoryLabel.isHidden = false
        self.subcategoryLabel.isHidden = false
        self.contactNameLabel.isHidden = false
        self.descriptionLabel.isHidden = false
        self.countiesLabel.isHidden = false
    }

}
