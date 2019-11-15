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
        
        if model.categories.count == 0 {
            self.categoryLabel.isHidden = true
        }
        else {
            self.categoryLabel.text = model.categories.first
        }
        
        if let subcategories = model.subcategories {
            if subcategories.count == 0 {
                self.subcategoryLabel.isHidden = true
            }
            else if subcategories.count < 3 {
                self.subcategoryLabel.text = subcategories.joined(separator: " & ")
            }
            else {
                self.subcategoryLabel.text = "\(subcategories[0]), \(subcategories[1]) & more"
            }
        } else {
            self.subcategoryLabel.isHidden = true
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
    
    override func prepareForReuse() {
        self.categoryLabel.isHidden = false
        self.contactNameLabel.isHidden = false
        self.descriptionLabel.isHidden = false
        self.countiesLabel.isHidden = false
    }

}
