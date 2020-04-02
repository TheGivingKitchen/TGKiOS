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

class DonateHomeViewController: UITableViewController {

    @IBOutlet weak var topDescriptionLabel: UILabel!
    @IBOutlet weak var learnMoreButton: UIButton!
    @IBOutlet weak var useCreditCardButton: UIButton!
    @IBOutlet weak var donateTypeDividerView: UIView!
    @IBOutlet weak var recurringDonationButton: UIButton!
    @IBOutlet weak var donationAnimatedInfoView: UIView!
    @IBOutlet weak var amountView: UIView!
    @IBOutlet weak var amountAssociatedIconBackgroundView:UIView!
    @IBOutlet weak var amountAssociatedIcon: UIImageView!
    @IBOutlet weak var amountAssociatedIconLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var amountDescriptionView: UIView!
    @IBOutlet weak var amountDescriptionViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var amountDollarLabel: UILabel!
    @IBOutlet weak var amountDescriptionLabel: UILabel!
    @IBOutlet weak var amountViewBottomDividerView: UIView!
    
    @IBOutlet weak var donateBottomDividerView: UIView!
    @IBOutlet weak var volunteerHeaderLabel: UILabel!
    @IBOutlet weak var volunteerDescriptionLabel: UILabel!
    @IBOutlet weak var volunteerButton: UIButton!
    @IBOutlet weak var volunteerImageView: UIImageView!
    @IBOutlet weak var volunteerBottomDividerView: UIView!
    
    @IBOutlet weak var partnerHeaderLabel: UILabel!
    @IBOutlet weak var stabilityPartnerLabel: UILabel!
    @IBOutlet weak var partnerDividerView: UIView!
    @IBOutlet weak var stabilityPartnerButton: UIButton!
    @IBOutlet weak var eventPartnerDescriptionLabel: UILabel!
    @IBOutlet weak var eventPartnerButton: UIButton!
    @IBOutlet weak var partnerImageView: UIImageView!
    
    var amountAndDescriptions:[(amount:String, description:String, iconName:String)] = [("$25", "Funds a late fee", "donateIconLateBill"),
                                                   ("$50", "Funds a water bill", "donateIconWaterBill"),
                                                   ("$100", "Funds a power bill", "donateIconPowerBill"),
                                                   ("$150", "Funds a gas bill", "donateIconGasBill"),
                                                   ("$500", "Funds housing", "donateIconHousingBill"),
                                                   ("$1,800", "A total grant!", "donateIconTotalGrant"),
                                                   ("$5", "Every bit helps!", "donateIconAnyBill")]
    var currentAmountAndDescriptionIndex:Int = 1
    var volunteerFormModel:SegmentedFormModel?
    var eventPartnerFormModel:SegmentedFormModel?
    var stabilityPartnerFormModel:SegmentedFormModel?
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 400
        self.styleView()
        
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
        
        self.donationAnimatedInfoView.backgroundColor = UIColor.tgkBlue
        self.amountDescriptionView.backgroundColor = UIColor.tgkBlue
        self.amountAssociatedIconBackgroundView.backgroundColor = UIColor.tgkDarkBlue
        self.amountView.backgroundColor = UIColor.tgkBlue
        
        self.amountDescriptionLabel.font = UIFont.tgkBody
        
        self.amountDollarLabel.font = UIFont.kulturistaMedium(size: 60)
        
        self.amountViewBottomDividerView.backgroundColor = UIColor.tgkBackgroundGray
        
        self.useCreditCardButton.titleLabel?.font = UIFont.tgkNavigation
        self.useCreditCardButton.tintColor = UIColor.tgkOrange
        
        self.donateTypeDividerView.backgroundColor = UIColor.tgkBackgroundGray
        
        self.recurringDonationButton.titleLabel?.font = UIFont.tgkNavigation
        self.recurringDonationButton.tintColor = UIColor.tgkOrange
        
        self.donateBottomDividerView.backgroundColor = UIColor.tgkBackgroundGray
        
        self.volunteerHeaderLabel.font = UIFont.tgkBody
        self.volunteerHeaderLabel.textColor = UIColor.tgkGray
        
        self.volunteerDescriptionLabel.font = UIFont.tgkBody
        self.volunteerDescriptionLabel.textColor = UIColor.tgkDarkDarkGray
        
        self.volunteerButton.backgroundColor = UIColor.tgkOrange
        self.volunteerButton.titleLabel?.font = UIFont.tgkNavigation
        
        self.volunteerBottomDividerView.backgroundColor = UIColor.tgkBackgroundGray
        
        self.partnerHeaderLabel.font = UIFont.tgkBody
        self.partnerHeaderLabel.textColor = UIColor.tgkGray
        self.partnerDividerView.backgroundColor = UIColor.tgkBackgroundGray
        
        self.stabilityPartnerLabel.font = UIFont.tgkBody
        self.stabilityPartnerLabel.textColor = UIColor.tgkDarkDarkGray
        
        self.stabilityPartnerButton.backgroundColor = UIColor.tgkOrange
        self.stabilityPartnerButton.titleLabel?.font = UIFont.tgkNavigation
        
        self.eventPartnerDescriptionLabel.font = UIFont.tgkBody
        self.eventPartnerDescriptionLabel.textColor = UIColor.tgkDarkDarkGray
        
        self.eventPartnerButton.backgroundColor = UIColor.tgkOrange
        self.eventPartnerButton.titleLabel?.font = UIFont.tgkNavigation
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
        
        ServiceManager.sharedInstace.getFirebaseForm(id: "communityPartner") { (eventPartnerFormModel, error) in
            if let unwrappedModel = eventPartnerFormModel {
                self.eventPartnerFormModel = unwrappedModel
                self.eventPartnerButton.isEnabled = true
            }
        }
        
        ServiceManager.sharedInstace.getFirebaseForm(id: "stabilitynetworkpartner") { (stabilityPartnerFormModel, error) in
            if let unwrappedModel = stabilityPartnerFormModel {
                self.stabilityPartnerFormModel = unwrappedModel
                self.stabilityPartnerButton.isEnabled = true
            }
        }
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
                strongSelf.amountAssociatedIcon.image = UIImage(named: amountAndDescription.iconName)
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
            
            Analytics.logEvent(customName: .learnMorePressed, parameters: [.learnMoreType:"donate_home"])
        }
    }
    
    @IBAction func useCreditCardButtonPressed(_ sender: Any) {
        guard let externalDonationFormUrl = URL(string: "https://connect.clickandpledge.com/w/Form/d00e52d7-f298-4d35-8be9-05fd93d3194a") else {
            return
        }
        
        UIApplication.shared.open(externalDonationFormUrl, options: [:]) { (success) in
            self.presentMonetaryDonationSuccessScreen()
        }
        
        Analytics.logEvent(customName: .donateOneTimeDonationStarted)
    }
    
    @IBAction func recurringDonationPressed(_ sender: Any) {
        guard let externalDonationFormUrl = URL(string: "https://connect.clickandpledge.com/w/Form/a4eb8d47-b792-4285-8ef9-24c353715cd7") else {
            return
        }
        
        UIApplication.shared.open(externalDonationFormUrl, options: [:]) { (success) in
            self.presentMonetaryDonationSuccessScreen()
        }
        
        Analytics.logEvent(customName: .donateRecurringDonationStarted)
    }
    
    private func presentMonetaryDonationSuccessScreen() {
        DispatchQueue.main.async {
            let donationSuccessVC = DonationSuccessViewController.donationSuccessViewController(withDelegate: self)
            donationSuccessVC.titleLabelText = "welcome to the fight!"
            donationSuccessVC.messageLabelText = "Thank you for your donation. In supporting GK's mission, you share in our commitment to provide emergency assistance to food service workers, often locked in the fight of their lives, who serve their community every day."
            donationSuccessVC.shareText = "I support The Giving Kitchen and helping food service workers in need"
            donationSuccessVC.bottomLabelText = "Your donation is 100 percent tax deductible and truly makes a difference."
            donationSuccessVC.shareUrlString = "https://thegivingkitchen.org/"
            donationSuccessVC.shareImage = UIImage(named: "tgkShareIcon")
            self.present(donationSuccessVC, animated: true)
        }
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
    
    @IBAction func stabilityPartnerPressed(_ sender: Any) {
        guard let formModel = self.stabilityPartnerFormModel else {
            return
        }
        
        let segmentedNav = UIStoryboard(name: "Forms", bundle: nil).instantiateViewController(withIdentifier: "SegmentedFormNavigationControllerId") as! SegmentedFormNavigationController
        segmentedNav.segmentedFormModel = formModel
        segmentedNav.formDelegate = self
        self.present(segmentedNav, animated: true)
    }
    
    @IBAction func eventPartnerPressed(_ sender: Any) {
        guard let formModel = self.eventPartnerFormModel else {
            return
        }
        
        let segmentedNav = UIStoryboard(name: "Forms", bundle: nil).instantiateViewController(withIdentifier: "SegmentedFormNavigationControllerId") as! SegmentedFormNavigationController
        segmentedNav.segmentedFormModel = formModel
        segmentedNav.formDelegate = self
        self.present(segmentedNav, animated: true)
    }
}

//MARK: uitableview overrides for static table
extension DonateHomeViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

//MARK: Segmented Form Delegate
extension DonateHomeViewController:SegmentedFormNavigationControllerDelegate {
    func segmentedFormNavigationControllerDidFinish(viewController: SegmentedFormNavigationController) {
        viewController.dismiss(animated: true) {
            guard let volunteerModel = self.volunteerFormModel,
                let eventPartnerModel = self.eventPartnerFormModel,
                let stabilityPartnerModel = self.stabilityPartnerFormModel else {
                    return
            }
            
            if viewController.segmentedFormModel.id == volunteerModel.id {
                let successConfirmationVC = DonationSuccessViewController.donationSuccessViewController(withDelegate: self)
                successConfirmationVC.titleLabelText = "welcome to the fight!"
                successConfirmationVC.messageLabelText = "Thank you for signing up to be a GK volunteer! You'll be added to our volunteer newsletter to hear about opportunities each month and on an as-needed basis. From there, you can simply head over to our volunteer calendar and sign up for as many or as few opportunities as your heart desires."
                successConfirmationVC.shareText = "I signed up to be a GK Volunteer!"
                successConfirmationVC.shareUrlString = "https://thegivingkitchen.org/volunteer"
                successConfirmationVC.shareImage = UIImage(named: "tgkShareIcon")
                self.present(successConfirmationVC, animated: true)
            }
            else if viewController.segmentedFormModel.id == eventPartnerModel.id {
                let successConfirmationVC = DonationSuccessViewController.donationSuccessViewController(withDelegate: self)
                successConfirmationVC.titleLabelText = "thank you!"
                successConfirmationVC.messageLabelText = "Thank you for your interest in partnering with GK for an event. A member of our staff will reach out to you shortly with more details on how we can best work together."
                successConfirmationVC.shareText = "Support Giving Kitchen by hosting an event!"
                successConfirmationVC.shareUrlString = "https://thegivingkitchen.wufoo.com/forms/gk-community-partner-form/"
                successConfirmationVC.shareImage = UIImage(named: "tgkShareIcon")
                self.present(successConfirmationVC, animated: true)
            }
            else if viewController.segmentedFormModel.id == stabilityPartnerModel.id {
                let successConfirmationVC = DonationSuccessViewController.donationSuccessViewController(withDelegate: self)
                successConfirmationVC.titleLabelText = "thank you!"
                successConfirmationVC.messageLabelText = "Thank you for your service and interest in becoming a Giving Kitchen Stability Network partner. A member of our staff will reach out to you shortly with more details on how we can best work together."
                successConfirmationVC.shareText = "Become a Giving Kitchen Stability Network Partner!"
                successConfirmationVC.shareUrlString = "https://thegivingkitchen.wufoo.com/forms/z176lwo104hfvol/"
                successConfirmationVC.shareImage = UIImage(named: "tgkShareIcon")
                self.present(successConfirmationVC, animated: true)
            }
            
        }
    }
}

extension DonateHomeViewController:DonationSuccessViewControllerDelegate {
    func donationSuccessViewControllerDonePressed(viewController: DonationSuccessViewController) {
        viewController.dismiss(animated: true)
    }
}
