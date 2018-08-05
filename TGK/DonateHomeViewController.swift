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
    @IBOutlet weak var amountDescriptionLabel: UILabel!
    @IBOutlet weak var customAmountView: UIView!
    @IBOutlet weak var customAmountLabel: UILabel!
    @IBOutlet weak var dividerView: UIView!
    @IBOutlet weak var infoTitleLabel: UILabel!
    @IBOutlet weak var infoSubtitleLabel: UILabel!
    @IBOutlet weak var infoBodyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.styleView()
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
    }

    
    @IBAction func mainDonationFormPressed(_ sender: Any) {
        let safariVC = TGKSafariViewController(url: URL(string: "https://connect.clickandpledge.com/w/Form/d11bff52-0cd0-44d8-9403-465614e4f342")!)
        self.present(safariVC, animated: true)
    }
    
}
