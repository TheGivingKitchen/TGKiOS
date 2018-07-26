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
    @IBOutlet weak var startInquiryButton: UIButton!
    @IBOutlet weak var startInquiryDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.styleView()
    }
    
    private func styleView() {
        self.programDescriptionLabel.font = UIFont.tgkSubtitle
        self.programDescriptionLabel.textColor = UIColor.tgkBlue
        
        self.startInquiryButton.backgroundColor = UIColor.tgkOrange
        self.startInquiryButton.titleLabel?.font = UIFont.tgkNavigation
        
        self.startInquiryDescriptionLabel.font = UIFont.tgkMetadata
        self.startInquiryDescriptionLabel.textColor = UIColor.tgkLightGray
    }
    @IBAction func asdf(_ sender: Any) {
        print("hit")
    }
}
