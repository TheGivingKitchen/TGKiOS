//
//  OnboardingCollectionViewCell.swift
//  TGK
//
//  Created by Jay Park on 9/30/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    var onboardingModel:OnboardingContentModel!
    
    override func awakeFromNib() {
        self.styleView()
    }
    
    private func styleView() {
        
    }
    
    func configureWith(onboardingContentModel:OnboardingContentModel) {
        self.onboardingModel = onboardingContentModel
        
        self.imageView.image = onboardingModel.heroImage
    }
}
