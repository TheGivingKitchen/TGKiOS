//
//  DonateHomeViewController.swift
//  TGK
//
//  Created by Jay Park on 6/6/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import UIKit
import SafariServices
import PassKit
import Firebase

class DonateHomeViewController: UIViewController {

    @IBOutlet weak var topDescriptionLabel: UILabel!
    @IBOutlet weak var learnMoreButton: UIButton!
    @IBOutlet weak var useCreditCardButton: UIButton!
    @IBOutlet weak var donateTypeDividerView: UIView!
    @IBOutlet weak var recurringDonationButton: UIButton!
    @IBOutlet weak var amountView: UIView!
    @IBOutlet weak var amountAssociatedIconBackgroundView:UIView!
    @IBOutlet weak var amountAssociatedIcon: UIImageView!
    @IBOutlet weak var amountAssociatedIconLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var amountDescriptionView: UIView!
    @IBOutlet weak var amountDescriptionViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var amountDollarLabel: UILabel!
    @IBOutlet weak var amountDescriptionLabel: UILabel!
    @IBOutlet weak var firstDividerView: UIView!
    @IBOutlet weak var volunteerHeaderLabel: UILabel!
    @IBOutlet weak var volunteerDescriptionLabel: UILabel!
    @IBOutlet weak var volunteerButton: UIButton!
    @IBOutlet weak var volunteerImageView: UIImageView!
    @IBOutlet weak var secondDividerView: UIView!
    @IBOutlet weak var partnerHeaderLabel: UILabel!
    @IBOutlet weak var partnerDescriptionLabel: UILabel!
    @IBOutlet weak var partnerButton: UIButton!
    @IBOutlet weak var partnerImageView: UIImageView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    var amountAndDescriptions:[(amount:String, description:String)] = [("$25", "Covers a late fee"),
                                                   ("$50", "Covers a water bill"),
                                                   ("$100", "Covers a power bill"),
                                                   ("$150", "Covers a gas bill"),
                                                   ("$500", "Covers housing"),
                                                   ("$1800", "A total grant!!"),
                                                   ("$5", "Every bit helps!")]
    var currentAmountAndDescriptionIndex:Int = 1
    var volunteerFormModel:SegmentedFormModel?
    var safetyNetParterFormModel:SegmentedFormModel?
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.styleView()
        let endEditTapGestureRec = UITapGestureRecognizer(target: self, action: #selector(self.endEditing))
        self.mainScrollView.addGestureRecognizer(endEditTapGestureRec)
        
        self.fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.startTimer()
        self.navigationController?.navigationBar.isHidden = true
        self.fetchData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.timer.invalidate()
    }
    
    func styleView() {
        self.topDescriptionLabel.font = UIFont.tgkSubtitle
        self.topDescriptionLabel.textColor = UIColor.tgkBlue
        
        self.learnMoreButton.setTitleColor(UIColor.tgkOrange, for: .normal)
        self.learnMoreButton.titleLabel?.font = UIFont.tgkBody
        
        self.amountDescriptionView.backgroundColor = UIColor.tgkBlue
        self.amountAssociatedIconBackgroundView.backgroundColor = UIColor.tgkDarkBlue
        self.amountView.backgroundColor = UIColor.tgkBlue
        
        self.amountDescriptionLabel.font = UIFont.tgkBody
        
        self.amountDollarLabel.font = UIFont.kulturistaMedium(size: 60)
        
        self.useCreditCardButton.titleLabel?.font = UIFont.tgkNavigation
        self.useCreditCardButton.tintColor = UIColor.tgkOrange
        
        self.donateTypeDividerView.backgroundColor = UIColor.tgkBackgroundGray
        
        self.recurringDonationButton.titleLabel?.font = UIFont.tgkNavigation
        self.recurringDonationButton.tintColor = UIColor.tgkOrange
        
        self.firstDividerView.backgroundColor = UIColor.tgkBackgroundGray
        
        self.volunteerHeaderLabel.font = UIFont.tgkBody
        self.volunteerHeaderLabel.textColor = UIColor.tgkGray
        
        self.volunteerDescriptionLabel.font = UIFont.tgkBody
        self.volunteerDescriptionLabel.textColor = UIColor.tgkDarkDarkGray
        
        self.volunteerButton.backgroundColor = UIColor.tgkOrange
        self.volunteerButton.titleLabel?.font = UIFont.tgkNavigation
        
        self.secondDividerView.backgroundColor = UIColor.tgkBackgroundGray
        
        self.partnerHeaderLabel.font = UIFont.tgkBody
        self.partnerHeaderLabel.textColor = UIColor.tgkGray
        
        self.partnerDescriptionLabel.font = UIFont.tgkBody
        self.partnerDescriptionLabel.textColor = UIColor.tgkDarkDarkGray
        
        self.partnerButton.backgroundColor = UIColor.tgkOrange
        self.partnerButton.titleLabel?.font = UIFont.tgkNavigation
    }
    
    func startTimer() {
        self.timer = Timer(timeInterval: 3.0, target: self, selector: #selector(timerUpdateDonationDescription), userInfo: nil, repeats: true)
        self.timer.tolerance = 0.2
        RunLoop.current.add(self.timer, forMode: .commonModes)
    }
    
    func fetchData() {
        ServiceManager.sharedInstace.getFirebaseForm(id: "volunteerSignup") { (volunteerFormModel, error) in
            if let unwrappedModel = volunteerFormModel {
                self.volunteerFormModel = unwrappedModel
                self.volunteerButton.isEnabled = true
            }
        }
        
        ServiceManager.sharedInstace.getFirebaseForm(id: "safetyNetPartner") { (safetyNetFormModel, error) in
            if let unwrappedModel = safetyNetFormModel {
                self.safetyNetParterFormModel = unwrappedModel
                self.partnerButton.isEnabled = true
            }
        }
    }
    
    @objc func endEditing() {
        self.view.endEditing(true)
    }
    
    @objc func timerUpdateDonationDescription() {
        self.currentAmountAndDescriptionIndex += 1
        if self.currentAmountAndDescriptionIndex >= self.amountAndDescriptions.count {
            self.currentAmountAndDescriptionIndex = 0
        }
        let amountAndDescription = self.amountAndDescriptions[self.currentAmountAndDescriptionIndex]
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: {[weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.amountAssociatedIconLeadingConstraint.constant = strongSelf.amountAssociatedIcon.bounds.width * -1
            strongSelf.amountDescriptionViewTrailingConstraint.constant = strongSelf.amountDescriptionView.bounds.width * -2
            strongSelf.view.layoutIfNeeded()
            
        }) {(finished) in
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: {[weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.amountDollarLabel.text = amountAndDescription.amount
                strongSelf.amountDescriptionLabel.text = amountAndDescription.description
                strongSelf.amountAssociatedIconLeadingConstraint.constant = 0
                strongSelf.amountDescriptionViewTrailingConstraint.constant = 0
                strongSelf.view.layoutIfNeeded()
                
            }) {[weak self] (finished) in
                //return home if we get interrupted for some reason
                guard let strongSelf = self else {
                    return
                }
                if !finished {
                    strongSelf.amountAssociatedIconLeadingConstraint.constant = 0
                    strongSelf.amountDescriptionViewTrailingConstraint.constant = 0
                    strongSelf.view.layoutIfNeeded()
                }
            }
        }
    }
    
    @IBAction func learnMorePressed(_ sender: Any) {
        if let url = URL(string: "https://thegivingkitchen.org/support/") {
            let learnMoreVC = TGKSafariViewController(url: url)
            self.present(learnMoreVC, animated:true)
        }
    }
    
    @IBAction func useCreditCardButtonPressed(_ sender: Any) {
        ///live address
        /// test wufoo form https://thegivingkitchen.wufoo.com/forms/credit-card-donation-user-testing/
        guard let externalDonationFormUrl = URL(string: "https://connect.clickandpledge.com/w/Form/d11bff52-0cd0-44d8-9403-465614e4f342") else {
            return
        }
        
        UIApplication.shared.open(externalDonationFormUrl, options: [:]) { (success) in
            DispatchQueue.main.async {
                let donationSuccessVC = DonationSuccessViewController.donationSuccessViewController(withDelegate: self)
                self.present(donationSuccessVC, animated: true)
            }
        }
        
        Analytics.logEvent(customName: .donateOneTimeDonationStarted)
    }
    
    @IBAction func recurringDonationPressed(_ sender: Any) {
        guard let externalDonationFormUrl = URL(string: "https://connect.clickandpledge.com/w/Form/40b3de1f-fa46-4735-874f-c152e272620e") else {
            return
        }
        
        UIApplication.shared.open(externalDonationFormUrl, options: [:]) { (success) in
            DispatchQueue.main.async {
                let donationSuccessVC = DonationSuccessViewController.donationSuccessViewController(withDelegate: self)
                self.present(donationSuccessVC, animated: true)
            }
        }
        
        Analytics.logEvent(customName: .donateRecurringDonationStarted)
    }
    
    @IBAction func volunteerPressed(_ sender: Any) {
        guard let formModel = self.volunteerFormModel else {
            return
        }
        
        let segmentedNav = UIStoryboard(name: "Forms", bundle: nil).instantiateViewController(withIdentifier: "SegmentedFormNavigationControllerId") as! SegmentedFormNavigationController
        segmentedNav.segmentedFormModel = formModel
        segmentedNav.formDelegate = self
        self.present(segmentedNav, animated: true)
    }
    
    @IBAction func safetyNetPartnerPressed(_ sender: Any) {
        guard let formModel = self.safetyNetParterFormModel else {
            return
        }
        
        let segmentedNav = UIStoryboard(name: "Forms", bundle: nil).instantiateViewController(withIdentifier: "SegmentedFormNavigationControllerId") as! SegmentedFormNavigationController
        segmentedNav.segmentedFormModel = formModel
        segmentedNav.formDelegate = self
        self.present(segmentedNav, animated: true)
    }
}

extension DonateHomeViewController:DonationSuccessViewControllerDelegate {
    func donationSuccessViewControllerDonePressed(viewController: DonationSuccessViewController) {
        viewController.dismiss(animated: true)
    }
}

//MARK: Segmented Form Delegate
extension DonateHomeViewController:SegmentedFormNavigationControllerDelegate {
    func segmentedFormNavigationControllerDidFinish(viewController: SegmentedFormNavigationController) {
        viewController.dismiss(animated: true) {
        }
    }
}
