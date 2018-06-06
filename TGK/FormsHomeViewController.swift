//
//  FormsHomeViewController.swift
//  TGK
//
//  Created by Jay Park on 5/20/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import UIKit

class FormsHomeViewController: UIViewController, SegmentedFormInfoViewControllerDelegate {

    @IBOutlet weak var assistanceButton: UIButton!
    @IBOutlet weak var volunteerButton: UIButton!
    @IBOutlet weak var assistanceSelfButton: UIButton!
    @IBOutlet weak var assistanceReferralButton: UIButton!
    
    var assistanceFormModel:SegmentedFormModel!
    var assistanceSelfFormModel:SegmentedFormModel!
    var assistanceReferralFormModel:SegmentedFormModel!
    var volunteerFormModel:SegmentedFormModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.assistanceButton.isHidden = true
        self.volunteerButton.isHidden = true
        
        ServiceManager.sharedInstace.getFirebaseForm(id: "zl0n8dd0u0hk0z") { (formModel, error) in
            if let formModel = formModel {
                self.assistanceFormModel = formModel
                self.assistanceButton.isHidden = false
            }
        }
        
        ServiceManager.sharedInstace.getFirebaseForm(id: "z1a0tap91any17q") { (formModel, error) in
            if let formModel = formModel {
                self.volunteerFormModel = formModel
                self.volunteerButton.isHidden = false
            }
        }
        
        ServiceManager.sharedInstace.getFirebaseForm(id: "assistanceInquirySelf") { (formModel, error) in
            if let formModel = formModel {
                self.assistanceSelfFormModel = formModel
                self.assistanceSelfButton.isHidden = false
            }
        }
        
        ServiceManager.sharedInstace.getFirebaseForm(id: "assistanceInquiryReferral") { (formModel, error) in
            if let formModel = formModel {
                self.assistanceReferralFormModel = formModel
                self.assistanceReferralButton.isHidden = false
            }
        }
        
    }
    
    @IBAction func assistanceTapped(_ sender: Any) {
        let formInfoVC = UIStoryboard(name: "Forms", bundle: nil).instantiateViewController(withIdentifier: "SegmentedFormInfoViewControllerId") as! SegmentedFormInfoViewController
        formInfoVC.segmentedFormModel = self.assistanceFormModel
        formInfoVC.delegate = self
        self.navigationController?.pushViewController(formInfoVC, animated: true)
    }
    
    @IBAction func assistanceSelfTapped(_ sender: Any) {
        let formInfoVC = UIStoryboard(name: "Forms", bundle: nil).instantiateViewController(withIdentifier: "SegmentedFormInfoViewControllerId") as! SegmentedFormInfoViewController
        formInfoVC.segmentedFormModel = self.assistanceSelfFormModel
        formInfoVC.delegate = self
        self.navigationController?.pushViewController(formInfoVC, animated: true)
    }
    
    @IBAction func assistanceReferrlaTapped(_ sender: Any) {
        let formInfoVC = UIStoryboard(name: "Forms", bundle: nil).instantiateViewController(withIdentifier: "SegmentedFormInfoViewControllerId") as! SegmentedFormInfoViewController
        formInfoVC.segmentedFormModel = self.assistanceReferralFormModel
        formInfoVC.delegate = self
        self.navigationController?.pushViewController(formInfoVC, animated: true)
    }
    
    @IBAction func volunteerSignUpTapped(_ sender: Any) {
        let formInfoVC = UIStoryboard(name: "Forms", bundle: nil).instantiateViewController(withIdentifier: "SegmentedFormInfoViewControllerId") as! SegmentedFormInfoViewController
        formInfoVC.segmentedFormModel = self.volunteerFormModel
        formInfoVC.delegate = self
        self.navigationController?.pushViewController(formInfoVC, animated: true)
    }
    
    func segmentedFormInfoViewControllerDidPressContinue(segmentedFormInfoViewController: SegmentedFormInfoViewController) {
        let segmentedNav = UIStoryboard(name: "Forms", bundle: nil).instantiateViewController(withIdentifier: "SegmentedFormNavigationControllerId") as! SegmentedFormNavigationController
        segmentedNav.segmentedFormModel = segmentedFormInfoViewController.segmentedFormModel
        self.present(segmentedNav, animated: true)
    }
    
    func segmentedFormInfoViewControllerDidPressCancel(segmentedFormInfoViewController: SegmentedFormInfoViewController) {
        self.navigationController?.popViewController(animated: true)
    }
}
