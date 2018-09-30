//
//  OnboardingCollectionViewCell.swift
//  TGK
//
//  Created by Jay Park on 9/30/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var onboardingModel:OnboardingContentModel!
    
    override func awakeFromNib() {
        self.styleView()
    }
    
    private func styleView() {
        self.titleLabel.font = UIFont.tgkTitle
        self.titleLabel.textColor = UIColor.tgkOrange
        
        self.descriptionLabel.font = UIFont.tgkBody
        self.descriptionLabel.textColor = UIColor.tgkGray
    }
    
    func configureWith(onboardingContentModel:OnboardingContentModel) {
        self.onboardingModel = onboardingContentModel
        self.titleLabel.text = onboardingModel.title
        self.descriptionLabel.text = onboardingModel.description
        self.imageView.image = onboardingModel.heroImage
    }
}
