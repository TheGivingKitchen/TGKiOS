//
//  AssistanceChooseRecipientViewController.swift
//  TGK
//
//  Created by Jay Park on 7/24/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import UIKit

class AssistanceChooseRecipientViewController: UIViewController, SegmentedFormInfoViewControllerDelegate {

    @IBOutlet weak var meHeaderLabel: UILabel!
    @IBOutlet weak var meSubtitleLabel: UILabel!
    @IBOutlet weak var meStartButton: UIButton! {
        didSet {
            self.meStartButton.isEnabled = false
        }
    }
    
    @IBOutlet weak var otherHeaderLabel: UILabel!
    @IBOutlet weak var otherSubtitleLabel: UILabel!
    @IBOutlet weak var otherStartButton: UIButton! {
        didSet {
            self.otherStartButton.isEnabled = false
        }
    }
    
    var assistanceSelfFormModel:SegmentedFormModel?
    var assistanceReferralFormModel:SegmentedFormModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.styleView()
    }
    
    private func fetchData() {
        ServiceManager.sharedInstace.getFirebaseForm(id: "assistanceInquirySelf") { (formModel, error) in
            if let formModel = formModel {
                self.assistanceSelfFormModel = formModel
                self.meStartButton.isEnabled = true
            }
        }
        
        ServiceManager.sharedInstace.getFirebaseForm(id: "assistanceInquiryReferral") { (formModel, error) in
            if let formModel = formModel {
                self.assistanceReferralFormModel = formModel
                self.otherStartButton.isEnabled = true
            }
        }
    }
    
    private func styleView() {
        self.meHeaderLabel.font = UIFont.tgkSubtitle
        self.meHeaderLabel.textColor = UIColor.tgkOrange
        
        self.meSubtitleLabel.font = UIFont.tgkBody
        self.meSubtitleLabel.textColor = UIColor.tgkGray
        
        self.meStartButton.backgroundColor = UIColor.tgkOrange
        self.meStartButton.titleLabel?.font = UIFont.tgkNavigation
        
        self.otherHeaderLabel.font = UIFont.tgkSubtitle
        self.otherHeaderLabel.textColor = UIColor.tgkOrange
        
        self.otherSubtitleLabel.font = UIFont.tgkBody
        self.otherSubtitleLabel.textColor = UIColor.tgkGray
        
        self.otherStartButton.backgroundColor = UIColor.tgkOrange
        self.otherStartButton.titleLabel?.font = UIFont.tgkNavigation
    }
    
    @IBAction func meStartButtonPressed(_ sender: Any) {
        guard let selfForm = self.assistanceSelfFormModel else {
            return
        }
        
        let formInfoVC = UIStoryboard(name: "Forms", bundle: nil).instantiateViewController(withIdentifier: "SegmentedFormInfoViewControllerId") as! SegmentedFormInfoViewController
        formInfoVC.segmentedFormModel = selfForm
        formInfoVC.delegate = self
        self.navigationController?.pushViewController(formInfoVC, animated: true)
    }
    
    @IBAction func otherStartButtonPressed(_ sender: Any) {
        guard let referralForm = self.assistanceReferralFormModel else {
            return
        }
        
        let formInfoVC = UIStoryboard(name: "Forms", bundle: nil).instantiateViewController(withIdentifier: "SegmentedFormInfoViewControllerId") as! SegmentedFormInfoViewController
        formInfoVC.segmentedFormModel = referralForm
        formInfoVC.delegate = self
        self.navigationController?.pushViewController(formInfoVC, animated: true)
    }
    
}

//MARK: SegmentedFormInfoViewControllerDelegate
extension AssistanceChooseRecipientViewController {
    func segmentedFormInfoViewControllerDidPressContinue(segmentedFormInfoViewController: SegmentedFormInfoViewController) {
        let segmentedNav = UIStoryboard(name: "Forms", bundle: nil).instantiateViewController(withIdentifier: "SegmentedFormNavigationControllerId") as! SegmentedFormNavigationController
        segmentedNav.segmentedFormModel = segmentedFormInfoViewController.segmentedFormModel
        self.present(segmentedNav, animated: true)
    }
    
    func segmentedFormInfoViewControllerDidPressCancel(segmentedFormInfoViewController: SegmentedFormInfoViewController) {
        self.navigationController?.popViewController(animated: true)
    }
}
