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

    @IBOutlet weak var usdLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var useCreditCardButton: UIButton!
    @IBOutlet weak var donateTypeDividerView: UIView!
    @IBOutlet weak var recurringDonationButton: UIButton!
    @IBOutlet weak var amountView: UIView!
    @IBOutlet weak var decrementAmountButton: UIButton!
    @IBOutlet weak var incrementAmountButton: UIButton!
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
    
    var amountAndDescriptions:[(amount:Int, description:String)] = [(25, "Covers a late fee"),
                                                   (50, "Covers a water bill"),
                                                   (100, "Covers a power bill"),
                                                   (150, "Covers a gas bill"),
                                                   (500, "Covers housing"),
                                                   (1800, "A total grant!!")]
    var volunteerFormModel:SegmentedFormModel?
    var safetyNetParterFormModel:SegmentedFormModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.styleView()
        let endEditTapGestureRec = UITapGestureRecognizer(target: self, action: #selector(self.endEditing))
        self.mainScrollView.addGestureRecognizer(endEditTapGestureRec)
        self.fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.fetchData()
    }
    
    func styleView() {
        self.amountView.backgroundColor = UIColor.tgkBlue
        
        self.amountDescriptionLabel.font = UIFont.tgkBody
        
        self.amountTextField.font = UIFont.kulturistaBold(size: 60)
        self.amountTextField.text = "50"
        
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
        
        self.configureStateForIncrementAndDecrementButtons()
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
    
    @IBAction func incrementAmountPressed(_ sender: Any) {
        for (amount, description) in self.amountAndDescriptions {
            if let amountString = self.amountTextField.text,
                let currentAmount = Int(amountString),
                amount > currentAmount {
                self.amountTextField.text = String(amount)
                self.amountDescriptionLabel.text = description
                self.configureStateForIncrementAndDecrementButtons()
                break
            }
        }
    }
    
    @IBAction func decrementAmountPressed(_ sender: Any) {
        for (amount, description) in self.amountAndDescriptions.reversed() {
            if let amountString = self.amountTextField.text,
                let currentAmount = Int(amountString),
                amount < currentAmount {
                self.amountTextField.text = String(amount)
                self.amountDescriptionLabel.text = description
                self.configureStateForIncrementAndDecrementButtons()
                break
            }
        }
    }
    
    @IBAction func amountTextFieldDidEndEditing(_ sender: Any) {
        //if the user manages to copy paste something bad into the text field, reset
        guard let amountString = self.amountTextField.text,
            let currentAmount = Int(amountString) else {
                if let firstAmountAndDescription = self.amountAndDescriptions.first {
                    self.amountTextField.text = String(firstAmountAndDescription.amount)
                    self.amountDescriptionLabel.text = firstAmountAndDescription.description
                }
                self.configureStateForIncrementAndDecrementButtons()
                return
        }
        
        //if you hit a preconfigured amount, update the description label
        var didFindMatchingAmount = false
        for (amount, description) in self.amountAndDescriptions {
            if currentAmount == amount {
                self.amountDescriptionLabel.text = description
                didFindMatchingAmount = true
                break
            }
        }
        if !didFindMatchingAmount {
            self.amountDescriptionLabel.text = "Custom amount"
        }
        
        self.configureStateForIncrementAndDecrementButtons()
    }
    
    func configureStateForIncrementAndDecrementButtons() {
        guard let amountString = self.amountTextField.text,
            let currentAmount = Int(amountString) else {
                return
        }
        
        if let lowestAmountAndDescription = self.amountAndDescriptions.first {
            if currentAmount <= lowestAmountAndDescription.amount {
                self.incrementAmountButton.isEnabled = true
                self.decrementAmountButton.isEnabled = false
                return
            }
        }
        
        if let highestAmountAndDescription = self.amountAndDescriptions.last {
            if currentAmount >= highestAmountAndDescription.amount {
                self.incrementAmountButton.isEnabled = false
                self.decrementAmountButton.isEnabled = true
                return
            }
        }
        
        //if the current amount is inbetween the highest and lowest preset donation amounts
        self.incrementAmountButton.isEnabled = true
        self.decrementAmountButton.isEnabled = true
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
