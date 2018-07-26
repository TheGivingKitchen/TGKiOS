//
//  AssistanceOverviewCollectionViewCell.swift
//  TGK
//
//  Created by Jay Park on 7/4/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import UIKit

class AssistanceOverviewCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var programDescriptionLabel: UILabel!
    @IBOutlet weak var startInquiryLabel: UILabel!
    
    @IBOutlet weak var startSelfInquiryButton: UIButton!
    @IBOutlet weak var startReferralInquiryButton: UIButton!
    @IBOutlet weak var shareFormButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.styleView()
    }
    
    private func styleView() {
        self.programDescriptionLabel.font = UIFont.tgkSubtitle
        self.programDescriptionLabel.textColor = UIColor.tgkBlue
        
        self.startSelfInquiryButton.backgroundColor = UIColor.tgkOrange
        self.startSelfInquiryButton.titleLabel?.font = UIFont.tgkNavigation
        
        self.startReferralInquiryButton.backgroundColor = UIColor.tgkOrange
        self.startReferralInquiryButton.titleLabel?.font = UIFont.tgkNavigation
        
        self.startInquiryLabel.font = UIFont.tgkBody
        self.startInquiryLabel.textColor = UIColor.tgkGray
        
        self.shareFormButton.titleLabel?.font = UIFont.tgkBody
        self.shareFormButton.setTitleColor(UIColor.tgkLightGray, for: .normal)
        self.shareFormButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 25)
    }
}
