//
//  StabilityNetCatgeoryInfoCollectionViewCell.swift
//  TGK
//
//  Created by Jay Park on 8/18/19.
//  Copyright © 2019 TheGivingKitchen. All rights reserved.
//

import UIKit

class StabilityNetCatgeoryInfoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                self.contentView.layer.borderWidth = 5
                self.contentView.layer.borderColor = UIColor.tgkBlue.cgColor
            }
            else {
                self.contentView.layer.borderWidth = 0
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureWith(category:String) {
        let icon = UIImage(named: "stabilityNetCategoryIcon_\(category)")
        self.iconImageView.image = icon ?? UIImage(named: "stabilityNetCategoryIcon_health")
        self.categoryLabel.text = category
    }
}
