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
                self.contentView.layer.borderWidth = 3
                self.contentView.layer.borderColor = UIColor.tgkOrange.cgColor
            }
            else {
                self.contentView.layer.borderWidth = 0
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.categoryLabel.font = UIFont.kulturistaBold(size: 15)
        self.categoryLabel.textColor = UIColor.tgkBlue
        self.iconImageView.alpha = 0.4
    }
    
    func configureWith(category:String) {
        self.iconImageView.image = self.categoryImageFor(stabilityNetCategory: category)
        self.categoryLabel.text = category
    }
    
    func categoryImageFor(stabilityNetCategory:String) -> UIImage? {
        let okayChars = Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890")
        let sanitizedCategoryString = stabilityNetCategory.filter {okayChars.contains($0)}.lowercased()
        return UIImage(named: "stabilityNetCategoryIcon_\(sanitizedCategoryString)") ?? UIImage(named: "stabilityNetCategoryIcon_default")
    }
}
