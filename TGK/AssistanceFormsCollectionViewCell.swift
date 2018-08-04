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
    
    func assistanceFormsCellDidSelectMultiplyJoyShare(cell: AssistanceFormsCollectionViewCell)
    func assistanceFormsCellDidSelectVolunteerShare(cell: AssistanceFormsCollectionViewCell)
}

class AssistanceFormsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var pageHeaderLabel: UILabel!
    @IBOutlet weak var headerBottomDividerView: UIView!
    @IBOutlet weak var volunteerView: UIView!
    @IBOutlet weak var volunteerHeaderLabel: UILabel!
    @IBOutlet weak var volunteerSubtitleLabel: UILabel!
    @IBOutlet weak var volunteerShareButton: UIButton!
    @IBOutlet weak var volunteerBottomDividerView: UIView!
    
    @IBOutlet weak var multiplyJoyView: UIView!
    @IBOutlet weak var multiplyJoyHeaderLabel: UILabel!
    @IBOutlet weak var multiplyJoySubtitleLabel: UILabel!
    @IBOutlet weak var multiplyJoyShareButton: UIButton!
    @IBOutlet weak var multiplyJoyBottomDivider: UIView!
    
    weak var delegate:AssistanceFormsCollectionViewCellDelegate?
    var volunteerFormModel:SegmentedFormModel?
    var multiplyJoyModel:SegmentedFormModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.styleView()
        self.fetchForms()
        
        let volunteerTapGR = UITapGestureRecognizer(target: self, action: #selector(startVolunteerForm))
        self.volunteerView.addGestureRecognizer(volunteerTapGR)
        let multiplyTapGR = UITapGestureRecognizer(target: self, action: #selector(startMultiplyJoyPressed))
        self.multiplyJoyView.addGestureRecognizer(multiplyTapGR)
    }
    
    private func styleView() {
        self.pageHeaderLabel.font = UIFont.tgkSubtitle
        self.pageHeaderLabel.textColor = UIColor.tgkOrange
        
        self.volunteerHeaderLabel.font = UIFont.tgkSubtitle
        self.volunteerHeaderLabel.textColor = UIColor.tgkOrange
        
        self.volunteerSubtitleLabel.font = UIFont.tgkBody
        self.volunteerSubtitleLabel.textColor = UIColor.tgkGray

        self.volunteerShareButton.titleLabel?.font = UIFont.tgkBody
        self.volunteerShareButton.setTitleColor(UIColor.tgkLightGray, for: .normal)
        
        self.multiplyJoyHeaderLabel.font = UIFont.tgkSubtitle
        self.multiplyJoyHeaderLabel.textColor = UIColor.tgkOrange
        
        self.multiplyJoySubtitleLabel.font = UIFont.tgkBody
        self.multiplyJoySubtitleLabel.textColor = UIColor.tgkGray

        self.multiplyJoyShareButton.titleLabel?.font = UIFont.tgkBody
        self.multiplyJoyShareButton.setTitleColor(UIColor.tgkLightGray, for: .normal)
        
        self.headerBottomDividerView.backgroundColor = UIColor.tgkBackgroundGray
        self.volunteerBottomDividerView.backgroundColor = UIColor.tgkBackgroundGray
        self.multiplyJoyBottomDivider.backgroundColor = UIColor.tgkBackgroundGray
    }
    
    func fetchForms() {
        ServiceManager.sharedInstace.getFirebaseForm(id: "multiplyJoyInquiry") { (formModel, error) in
            if let formModel = formModel {
                self.multiplyJoyModel = formModel
            }
        }
        
        ServiceManager.sharedInstace.getFirebaseForm(id: "volunteerSignup") { (formModel, error) in
            if let formModel = formModel {
                self.volunteerFormModel = formModel
            }
        }
    }
    
    @objc func startMultiplyJoyPressed() {
        self.delegate?.assistanceFormsCellDidSelectMultiplyJoyForm(cell: self)
    }
    
    @objc func startVolunteerForm() {
        self.delegate?.assistanceFormsCellDidSelectVolunteerForm(cell: self)
    }
    
    @IBAction func volunteerSharePressed(_ sender: Any) {
        self.delegate?.assistanceFormsCellDidSelectVolunteerShare(cell: self)
    }
    
    @IBAction func multiplyJoyPressed(_ sender: Any) {
        self.delegate?.assistanceFormsCellDidSelectMultiplyJoyShare(cell: self)
    }
    
}
