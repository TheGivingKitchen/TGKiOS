//
//  DonateHomeViewController.swift
//  TGK
//
//  Created by Jay Park on 6/6/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import UIKit
import SafariServices

class DonateHomeViewController: UIViewController {

    @IBOutlet weak var usdLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var useCreditCardButton: UIButton!
    @IBOutlet weak var amountView: UIView!
    @IBOutlet weak var decrementAmountButton: UIButton!
    @IBOutlet weak var incrementAmountButton: UIButton!
    @IBOutlet weak var amountDescriptionLabel: UILabel!
    @IBOutlet weak var customAmountView: UIView!
    @IBOutlet weak var customAmountLabel: UILabel!
    @IBOutlet weak var dividerView: UIView!
    @IBOutlet weak var infoTitleLabel: UILabel!
    @IBOutlet weak var infoSubtitleLabel: UILabel!
    @IBOutlet weak var infoBodyLabel: UILabel!
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    var amountAndDescriptions:[(amount:Int, description:String)] = [(50, "Covers a water bill"),
                                                   (100, "Covers a power bill"),
                                                   (150, "Covers a gas bill"),
                                                   (500, "Covers housing"),
                                                   (1800, "A total grant!!")]
    
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
        self.customAmountView.backgroundColor = UIColor.tgkDarkBlue
        
        self.amountDescriptionLabel.font = UIFont.tgkBody
        self.customAmountLabel.font = UIFont.tgkBody
        self.customAmountLabel.textColor = UIColor.tgkLightGray
        
        self.amountTextField.font = UIFont.kulturistaBold(size: 60)
        self.amountTextField.text = "50"
        self.useCreditCardButton.titleLabel?.font = UIFont.tgkNavigation
        self.useCreditCardButton.tintColor = UIColor.tgkOrange
        
        self.dividerView.backgroundColor = UIColor.tgkLightGray
        
        self.infoTitleLabel.font = UIFont.tgkSubtitle
        self.infoTitleLabel.textColor = UIColor.tgkOrange
        
        self.infoSubtitleLabel.font = UIFont.tgkNavigation
        self.infoSubtitleLabel.textColor = UIColor.tgkBlue
        
        self.infoBodyLabel.font = UIFont.tgkBody
        self.infoBodyLabel.textColor = UIColor.tgkGray
        
        self.infoTitleLabel.text = "the giving kitchen\ngives guidance."
        self.infoSubtitleLabel.text = "The Giving Kitchen cares for the most hard-working and vulnerable members of our community: restaurant workers."
        self.infoBodyLabel.text = "Welcome to the fight! In supporting GK’s mission, you share in our commitment to provide emergency assistance to restaurant workers, often locked in the fight of their lives, who serve their community every day. Your donation is 100 percent tax deductible and truly makes a difference."
        
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
        
        let safariVC = TGKSafariViewController(url: URL(string: "https://thegivingkitchen.wufoo.com/forms/credit-card-donation-user-testing/")!)
        self.present(safariVC, animated: true)
    }
}
