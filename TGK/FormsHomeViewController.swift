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
    @IBOutlet weak var multiplyJoyButton: UIButton!
    
    var assistanceFormModel:SegmentedFormModel!
    var assistanceSelfFormModel:SegmentedFormModel!
    var assistanceReferralFormModel:SegmentedFormModel!
    var volunteerFormModel:SegmentedFormModel!
    var multiplyJoyModel:SegmentedFormModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.assistanceButton.isHidden = true
        self.volunteerButton.isHidden = true
        
        ServiceManager.sharedInstace.getFirebaseForm(id: "assistanceInquiry") { (formModel, error) in
            if let formModel = formModel {
                self.assistanceFormModel = formModel
                self.assistanceButton.isHidden = false
            }
        }
        
        ServiceManager.sharedInstace.getFirebaseForm(id: "volunteerSignup") { (formModel, error) in
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
        
        ServiceManager.sharedInstace.getFirebaseForm(id: "multiplyJoyInquiry") { (formModel, error) in
            if let formModel = formModel {
                self.multiplyJoyModel = formModel
                self.multiplyJoyButton.isHidden = false
            }
        }
        
    }
    @IBAction func infoPressed(_ sender: Any) {
        let formInfoVC = UIStoryboard(name: "Forms", bundle: nil).instantiateViewController(withIdentifier: "SegmentedFormInfoViewControllerId") as! SegmentedFormInfoViewController
        _ = formInfoVC.view
        self.navigationController?.pushViewController(formInfoVC, animated: true)
        
        formInfoVC.formMetadata.text = "Our Crisis Grants program currently serve restaurant workers living in Metro Atlanta, Athens, Columbus and Rome. Grants are awarded based on the restaurant worker's financial need as well as a set of criteria according to the type of crisis. Most often, our financial assistance covers the cost of rent and utilities, paid directly to the service provider(s). Applications are reviewed by Giving Kitchen staff and a review committee consisting of GK board members. The average time to fully process an application from beginning to end is three weeks.\n\nPlease note: we do not pay medical expenses."
        
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
    
    @IBAction func multiplyJoyTapped(_ sender: Any) {
        let formInfoVC = UIStoryboard(name: "Forms", bundle: nil).instantiateViewController(withIdentifier: "SegmentedFormInfoViewControllerId") as! SegmentedFormInfoViewController
        formInfoVC.segmentedFormModel = self.multiplyJoyModel
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
