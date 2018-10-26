//
//  AssistanceHomeViewController.swift
//  TGK
//
//  Created by Jay Park on 6/6/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import UIKit
import Firebase

class AssistanceHomeViewController: UIViewController {
    
    @IBOutlet weak var programDescriptionLabel: UILabel!
    @IBOutlet weak var requestAssistanceLabel: UILabel!
    
    @IBOutlet weak var startSelfInquiryButton: UIButton! {
        didSet {
            self.startSelfInquiryButton.isEnabled = false
        }
    }
    @IBOutlet weak var startReferralInquiryButton: UIButton! {
        didSet {
            self.startReferralInquiryButton.isEnabled = false
        }
    }
    @IBOutlet weak var startFormInfoLabel: UILabel!
    @IBOutlet weak var learnMoreButton: UIButton!

    var selfAssistanceFormModel:SegmentedFormModel?
    var referralAssistanceFormModel:SegmentedFormModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchFormsIfNeeded()
        self.styleView()
    }
    
    private func styleView() {
        self.programDescriptionLabel.font = UIFont.tgkSubtitle
        self.programDescriptionLabel.textColor = UIColor.tgkBlue
        
        self.learnMoreButton.titleLabel?.font = UIFont.tgkBody
        self.learnMoreButton.tintColor = UIColor.tgkOrange
        
        self.startSelfInquiryButton.backgroundColor = UIColor.tgkOrange
        self.startSelfInquiryButton.titleLabel?.font = UIFont.tgkNavigation
        
        self.startReferralInquiryButton.backgroundColor = UIColor.tgkOrange
        self.startReferralInquiryButton.titleLabel?.font = UIFont.tgkNavigation
        
        self.requestAssistanceLabel.font = UIFont.tgkBody
        self.requestAssistanceLabel.textColor = UIColor.tgkDarkGray
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.fetchFormsIfNeeded()
    }
    
    func fetchFormsIfNeeded() {
        ServiceManager.sharedInstace.getFirebaseForm(id: "assistanceInquirySelf") { (formModel, error) in
            if let formModel = formModel {
                self.selfAssistanceFormModel = formModel
                self.startSelfInquiryButton.isEnabled = true
            }
        }
        
        ServiceManager.sharedInstace.getFirebaseForm(id: "assistanceInquiryReferral") { (formModel, error) in
            if let formModel = formModel {
                self.referralAssistanceFormModel = formModel
                self.startReferralInquiryButton.isEnabled = true
            }
        }
    }
    
    @IBAction func learnMorePressed(_ sender: Any) {
        if let url = URL(string: "https://thegivingkitchen.org/grant-program") {
            let learnMoreVC = TGKSafariViewController(url: url)
            self.present(learnMoreVC, animated:true)
        }
    }
    
    @IBAction func startSelfAssistancePressed(_ sender: Any) {
        guard let inquiryForm = self.selfAssistanceFormModel else {
            return
        }
        
        let segmentedNav = UIStoryboard(name: "Forms", bundle: nil).instantiateViewController(withIdentifier: "SegmentedFormNavigationControllerId") as! SegmentedFormNavigationController
        segmentedNav.segmentedFormModel = inquiryForm
        segmentedNav.formDelegate = self
        self.present(segmentedNav, animated: true)
    }
    
    @IBAction func startReferralAssistancePressed(_ sender: Any) {
        guard let inquiryForm = self.referralAssistanceFormModel else {
            return
        }
        
        let segmentedNav = UIStoryboard(name: "Forms", bundle: nil).instantiateViewController(withIdentifier: "SegmentedFormNavigationControllerId") as! SegmentedFormNavigationController
        segmentedNav.segmentedFormModel = inquiryForm
        segmentedNav.formDelegate = self
        self.present(segmentedNav, animated: true)
    }
    
}


//MARK: Segmented Form Delegate
extension AssistanceHomeViewController:SegmentedFormNavigationControllerDelegate {
    func segmentedFormNavigationControllerDidFinish(viewController: SegmentedFormNavigationController) {
        viewController.dismiss(animated: true) {
            let successVC = AssistanceSuccessViewController.assistanceSuccessViewController(withDelegate: self)
            self.present(successVC, animated:true)
        }
    }
}

//MARK: AssistanceSuccessViewControllerDelegate
extension AssistanceHomeViewController:AssistanceSuccessViewControllerDelegate {
    func assistanceSuccessViewControllerDelegateDonePressed(viewController: AssistanceSuccessViewController) {
        viewController.dismiss(animated: true)
    }
}
