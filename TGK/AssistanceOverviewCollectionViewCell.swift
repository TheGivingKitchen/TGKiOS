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
    @IBOutlet weak var startFormInfoLabel: UILabel!
    
    
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
        
        self.startFormInfoLabel.font = UIFont.tgkMetadata
        self.startFormInfoLabel.textColor = UIColor.tgkLightGray
        
        if let programDescriptionString = self.programDescriptionLabel.text {
            let crisisGrantRange = (programDescriptionString as NSString).range(of: "CRISIS GRANTS")
            let illnessRange = (programDescriptionString as NSString).range(of: "illness")
            let injuryRange = (programDescriptionString as NSString).range(of: "injury")
            let deathString = (programDescriptionString as NSString).range(of: "death")
            let disasterString = (programDescriptionString as NSString).range(of: "disaster")
            
            let programAttributedString = NSMutableAttributedString(string: programDescriptionString, attributes: [NSAttributedStringKey.foregroundColor:UIColor.tgkBlue])
            programAttributedString.addAttribute(.foregroundColor, value: UIColor.tgkOrange, range: crisisGrantRange)
            programAttributedString.addAttribute(.foregroundColor, value: UIColor.tgkOrange, range: illnessRange)
            programAttributedString.addAttribute(.foregroundColor, value: UIColor.tgkOrange, range: injuryRange)
            programAttributedString.addAttribute(.foregroundColor, value: UIColor.tgkOrange, range: deathString)
            programAttributedString.addAttribute(.foregroundColor, value: UIColor.tgkOrange, range: disasterString)
            self.programDescriptionLabel.attributedText = programAttributedString
        }
    }
}
