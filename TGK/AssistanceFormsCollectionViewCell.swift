//
//  AssistanceFormsCollectionViewCell.swift
//  TGK
//
//  Created by Jay Park on 7/4/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import UIKit

protocol AssistanceFormsCollectionViewCellDelegate:class {
    func assistanceFormsCellDidSelectMultiplyJoyForm(cell: AssistanceFormsCollectionViewCell)
    func assistanceFormsCellDidSelectVolunteerForm(cell: AssistanceFormsCollectionViewCell)
}

class AssistanceFormsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var pageHeaderLabel: UILabel!
    @IBOutlet weak var volunteerHeaderLabel: UILabel!
    @IBOutlet weak var volunteerSubtitleLabel: UILabel!
    @IBOutlet weak var volunteerStartFormButton: UIButton!
    @IBOutlet weak var volunteerShareButton: UIButton!
    @IBOutlet weak var volunteerBottomDividerView: UIView!
    
    @IBOutlet weak var multiplyJoyHeaderLabel: UILabel!
    @IBOutlet weak var multiplyJoySubtitleLabel: UILabel!
    @IBOutlet weak var multiplyJoyStartFormButton: UIButton!
    @IBOutlet weak var multiplyJoyShareButton: UIButton!
    @IBOutlet weak var multiplyJoyBottomDivider: UIView!
    
    
    weak var delegate:AssistanceFormsCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.styleView()
    }
    
    private func styleView() {
        self.pageHeaderLabel.font = UIFont.tgkContentTitle
        self.pageHeaderLabel.textColor = UIColor.tgkOrange
        
        self.volunteerHeaderLabel.font = UIFont.tgkSubtitle
        self.volunteerHeaderLabel.textColor = UIColor.tgkOrange
        
        self.volunteerSubtitleLabel.font = UIFont.tgkBody
        self.volunteerSubtitleLabel.textColor = UIColor.tgkGray
        
        self.volunteerStartFormButton.backgroundColor = UIColor.tgkOrange
        self.volunteerStartFormButton.titleLabel?.font = UIFont.tgkNavigation
        
        self.volunteerShareButton.titleLabel?.font = UIFont.tgkBody
        self.volunteerShareButton.titleLabel?.textColor = UIColor.tgkBackgroundGray
        self.volunteerShareButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 25)
        
        self.multiplyJoyHeaderLabel.font = UIFont.tgkSubtitle
        self.multiplyJoyHeaderLabel.textColor = UIColor.tgkOrange
        
        self.multiplyJoySubtitleLabel.font = UIFont.tgkBody
        self.multiplyJoySubtitleLabel.textColor = UIColor.tgkGray
        
        self.multiplyJoyStartFormButton.backgroundColor = UIColor.tgkOrange
        self.multiplyJoyStartFormButton.titleLabel?.font = UIFont.tgkNavigation
        
        self.multiplyJoyShareButton.titleLabel?.font = UIFont.tgkBody
        self.multiplyJoyShareButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 25)
        
        self.volunteerBottomDividerView.backgroundColor = UIColor.tgkBackgroundGray
        self.multiplyJoyBottomDivider.backgroundColor = UIColor.tgkBackgroundGray
    }
    
    @IBAction func startMultiplyJoyPressed(_ sender: Any) {
//        self.delegate?.assistanceFormsCellDidSelectMultiplyJoyForm(cell: self)
        print("multiply")
    }
    
    @IBAction func startVolunteerForm(_ sender: Any) {
        print("volunteer")
//        self.delegate?.assistanceFormsCellDidSelectVolunteerForm(cell: self)
    }
    
}
