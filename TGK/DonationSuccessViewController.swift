//
//  DonationSuccessViewController.swift
//  TGK
//
//  Created by Jay Park on 8/3/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import UIKit

protocol DonationSuccessViewControllerDelegate:class {
    func donationSuccessViewControllerDonePressed(viewController:DonationSuccessViewController)
}

class DonationSuccessViewController: UIViewController {
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var taxInfoLabel: UILabel!
    
    weak var delegate:DonationSuccessViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.welcomeLabel.font = UIFont.tgkTitle
        self.welcomeLabel.textColor = UIColor.tgkOrange
        
        self.messageLabel.font = UIFont.tgkBody
        self.messageLabel.textColor = UIColor.tgkGray
        
        self.shareButton.setTitleColor(UIColor.tgkLightGray, for: .normal)
        self.shareButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        
        self.doneButton.backgroundColor = UIColor.tgkOrange
        self.doneButton.titleLabel?.font = UIFont.tgkBody
        
        self.taxInfoLabel.font = UIFont.tgkBody
        self.taxInfoLabel.textColor = UIColor.tgkGray
    }
    
    @IBAction func sharePressed(_ sender: Any) {
        ExternalShareManager.sharedInstance.presentShareControllerFromViewController(fromController: self, title: "I support The Giving Kitchen and helping restaurants workers in need", urlString: "https://thegivingkitchen.org/", image: UIImage(named: "tgkShareIcon"))
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        self.delegate?.donationSuccessViewControllerDonePressed(viewController: self)
    }
    
}

extension DonationSuccessViewController {
    static func donationSuccessViewController(withDelegate delegate:DonationSuccessViewControllerDelegate) -> DonationSuccessViewController {
        let donationSuccessVC = UIStoryboard(name: "Donate", bundle: nil).instantiateViewController(withIdentifier: "DonationSuccessViewControllerId") as! DonationSuccessViewController
        donationSuccessVC.delegate = delegate
        return donationSuccessVC
    }
}
