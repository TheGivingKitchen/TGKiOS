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
    @IBOutlet weak var dividerView: UIView!
    @IBOutlet weak var pinInfoLabel: UILabel!
    @IBOutlet weak var secondDividerView: UIView!
    @IBOutlet weak var infoTitleLabel: UILabel!
    @IBOutlet weak var infoSubtitleLabel: UILabel!
    @IBOutlet weak var infoBodyLabel: UILabel!
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    
    var amountAndDescriptions:[(amount:Int, description:String)] = [(50, "Covers a water bill"),
                                                   (100, "Covers a power bill"),
                                                   (150, "Covers a gas bill"),
                                                   (500, "Covers housing"),
                                                   (1800, "A total grant!!")]
    
    let supportedPaymentNetworks:[PKPaymentNetwork] = [.visa, .masterCard, .amex]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.styleView()
        let endEditTapGestureRec = UITapGestureRecognizer(target: self, action: #selector(self.endEditing))
        self.mainScrollView.addGestureRecognizer(endEditTapGestureRec)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func styleView() {
        self.amountView.backgroundColor = UIColor.tgkBlue
        
        self.amountDescriptionLabel.font = UIFont.tgkBody
        
        self.amountTextField.font = UIFont.kulturistaBold(size: 60)
        self.amountTextField.text = "50"
        
        self.useCreditCardButton.titleLabel?.font = UIFont.tgkNavigation
        self.useCreditCardButton.tintColor = UIColor.tgkOrange
        
        self.recurringDonationButton.titleLabel?.font = UIFont.tgkNavigation
        self.recurringDonationButton.tintColor = UIColor.tgkOrange
        
        self.dividerView.backgroundColor = UIColor.tgkBackgroundGray
        self.secondDividerView.backgroundColor = UIColor.tgkBackgroundGray
        self.donateTypeDividerView.backgroundColor = UIColor.tgkBackgroundGray
        
        self.pinInfoLabel.font = UIFont.tgkBody
        self.pinInfoLabel.textColor = UIColor.tgkDarkGray
        
        self.infoTitleLabel.font = UIFont.tgkSubtitle
        self.infoTitleLabel.textColor = UIColor.tgkOrange
        
        self.infoSubtitleLabel.font = UIFont.tgkNavigation
        self.infoSubtitleLabel.textColor = UIColor.tgkBlue
        
        self.infoBodyLabel.font = UIFont.tgkBody
        self.infoBodyLabel.textColor = UIColor.tgkDarkGray
        
        self.pinInfoLabel.text = "You'll receive a GK button when you donate to cover part of a specific portion of a grant, and if you donate to cover a full grant, you'll receive a GK pin."
        self.infoTitleLabel.text = "the giving kitchen\ngives guidance."
        self.infoSubtitleLabel.text = "The Giving Kitchen is building a restaurant community where crisis is met with compassion and care, and anyone can be a hero."
        self.infoBodyLabel.text = "Stopping the cycle of poverty before it starts and offering a connection to social services needed to thrive after a crisis, we care for the most hard-working and vulnerable members of our community: restaurant workers.\n\n\nWelcome to the fight! In supporting GK’s mission, you share in our commitment to provide emergency assistance to restaurant workers, often locked in the fight of their lives, who serve their community every day. Your donation is 100 percent tax deductible and truly makes a difference."
        
        self.configureStateForIncrementAndDecrementButtons()
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
        //live address https://connect.clickandpledge.com/w/Form/d11bff52-0cd0-44d8-9403-465614e4f342
        
        guard let externalDonationFormUrl = URL(string: "https://thegivingkitchen.wufoo.com/forms/credit-card-donation-user-testing/") else {
            return
        }
        
        UIApplication.shared.open(externalDonationFormUrl, options: [:]) { (success) in
            DispatchQueue.main.async {
                let donationSuccessVC = DonationSuccessViewController.donationSuccessViewController(withDelegate: self)
                self.present(donationSuccessVC, animated: true)
            }
        }
    }
}

extension DonateHomeViewController:DonationSuccessViewControllerDelegate {
    func donationSuccessViewControllerDonePressed(viewController: DonationSuccessViewController) {
        viewController.dismiss(animated: true)
    }
}
