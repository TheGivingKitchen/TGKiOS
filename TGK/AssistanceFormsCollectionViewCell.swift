//
//  AssistanceFormsCollectionViewCell.swift
//  TGK
//
//  Created by Jay Park on 7/4/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import UIKit

class AssistanceFormsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var assistanceInquiryHeaderLabel: UILabel!
    @IBOutlet weak var assistanceInqurySubtitleLabel: UILabel!
    @IBOutlet weak var assistanceInquiryButton: UIButton!
    
    @IBOutlet weak var volunteerHeaderLabel: UILabel!
    @IBOutlet weak var volunteerSubtitleLabel: UILabel!
    @IBOutlet weak var volunteerButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.styleView()
    }
    
    private func styleView() {
        self.assistanceInquiryHeaderLabel.font = UIFont.tgkSubtitle
        self.assistanceInquiryHeaderLabel.textColor = UIColor.tgkOrange
        
        self.assistanceInqurySubtitleLabel.font = UIFont.tgkBody
        self.assistanceInqurySubtitleLabel.textColor = UIColor.tgkGray
        
        self.assistanceInquiryButton.backgroundColor = UIColor.tgkOrange
        self.assistanceInquiryButton.titleLabel?.font = UIFont.tgkNavigation
        
        self.volunteerHeaderLabel.font = UIFont.tgkSubtitle
        self.volunteerHeaderLabel.textColor = UIColor.tgkOrange
        
        self.volunteerSubtitleLabel.font = UIFont.tgkBody
        self.volunteerSubtitleLabel.textColor = UIColor.tgkGray
        
        self.volunteerButton.backgroundColor = UIColor.tgkOrange
        self.volunteerButton.titleLabel?.font = UIFont.tgkNavigation
    }
}
