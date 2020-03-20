//
//  StabilityNetFilterCategoryTypeCell.swift
//  TGK
//
//  Created by Jay Park on 2/22/20.
//  Copyright © 2020 TheGivingKitchen. All rights reserved.
//

import Foundation
import UIKit

protocol StabilityNetFilterCategoryTypeCellDelegate:class {
    func stabilityNetFilterCategoryTypeCellDidSetFilter(category:String, isActive:Bool)
}

class StabilityNetFilterCategoryTypeCell:UITableViewCell {
    
    @IBOutlet weak var isActiveSwitch: UISwitch!
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
    
    weak var delegate:StabilityNetFilterCategoryTypeCellDelegate?
    private var category:String?
    
    override func awakeFromNib() {
        self.styleView()
    }
    
    private func styleView() {
        self.backgroundColor = UIColor.clear
        self.isActiveSwitch.tintColor = UIColor.tgkYellow
        self.categoryNameLabel.font = UIFont.tgkNavigation
        self.categoryNameLabel.textColor = UIColor.tgkBlue
    }
    
    func configureWith(category:String, isOn:Bool) {
        self.categoryImage.image = categoryImageFor(stabilityNetCategory: category)
        self.categoryNameLabel.text = category
    }
    
    private func categoryImageFor(stabilityNetCategory:String) -> UIImage? {
        let okayChars = Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890")
        let sanitizedCategoryString = stabilityNetCategory.filter {okayChars.contains($0)}.lowercased()
        return UIImage(named: "stabilityNetCategoryIcon_\(sanitizedCategoryString)") ?? UIImage(named: "stabilityNetCategoryIcon_default")
    }
    
    override func prepareForReuse() {
        self.categoryImage.image = self.categoryImageFor(stabilityNetCategory: "") //reset to default image
        self.categoryNameLabel.text = ""
        self.isActiveSwitch.isOn = false
    }
    
    @IBAction func switchValueChanged(_ sender: Any) {
        if let category = self.category {
            self.delegate?.stabilityNetFilterCategoryTypeCellDidSetFilter(category: category, isActive: self.isActiveSwitch.isOn)
        }
        
    }
}
