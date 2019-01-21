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
    
    //Customization and dependencies
    weak var delegate:DonationSuccessViewControllerDelegate?
    var titleLabelText:String? {
        didSet {
            guard self.isViewLoaded else {return}
            self.configureView()
        }
    }
    var messageLabelText:String? {
        didSet {
            guard self.isViewLoaded else {return}
            self.configureView()
        }
    }
    var bottomLabelText:String? {
        didSet {
            guard self.isViewLoaded else {return}
            self.configureView()
        }
    }
    var shareText:String?
    var shareUrlString:String?
    var shareImage:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.styleView()
        self.configureView()
    }
    
    private func configureView() {
        self.welcomeLabel.text = titleLabelText
        self.messageLabel.text = messageLabelText
        self.taxInfoLabel.text = bottomLabelText
    }
    
    private func styleView() {
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
        guard let text = self.shareText,
            let urlString = self.shareUrlString else {
                return
        }
        ExternalShareManager.sharedInstance.presentShareControllerFromViewController(fromController: self, title: text, urlString: urlString, image: self.shareImage)
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
