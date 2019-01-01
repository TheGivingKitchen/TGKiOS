//
//  AboutHomeViewController.swift
//  TGK
//
//  Created by Jay Park on 12/17/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import UIKit
import MessageUI

class AboutHomeViewController: UIViewController {
    
    @IBOutlet weak var topTitleLabel: UILabel!
    @IBOutlet weak var topTitleLabelDivider: UIView!
    @IBOutlet weak var aboutUsLabel: UILabel!
    @IBOutlet weak var assistanceDescriptionLabel: UILabel!
    @IBOutlet weak var howItWorksButton: UIButton!
    
    @IBOutlet weak var storiesLabel: UILabel!
    @IBOutlet weak var story1Button: UIButton!
    @IBOutlet weak var story2Button: UIButton!
    @IBOutlet weak var story3Button: UIButton!
    
    @IBOutlet weak var storiesDividerView: UIView!
    @IBOutlet weak var story1Divider: UIView!
    @IBOutlet weak var story2Divider: UIView!
    
    @IBOutlet weak var feedbackDivider: UIView!
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var feedbackDescriptionLabel: UILabel!
    @IBOutlet weak var feedbackPositiveButton: UIButton!
    @IBOutlet weak var feedbackNegativeButton: UIButton!
    @IBOutlet weak var feedbackProblemButton: UIButton!
    @IBOutlet weak var feedbackDivider1: UIView!
    @IBOutlet weak var feedbackDivider2: UIView!
    @IBOutlet weak var feedbackDivider3: UIView!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.styleView()
    }
    
    private func styleView() {
        self.topTitleLabel.font = UIFont.tgkContentSmallTitle
        self.topTitleLabel.textColor = UIColor.tgkOrange
        
        self.topTitleLabelDivider.backgroundColor = UIColor.tgkBackgroundGray
        
        self.aboutUsLabel.font = UIFont.tgkBody
        self.aboutUsLabel.textColor = UIColor.tgkLightGray
        
        self.assistanceDescriptionLabel.font = UIFont.tgkBody
        self.assistanceDescriptionLabel.textColor = UIColor.tgkGray
        
        self.howItWorksButton.backgroundColor = UIColor.tgkOrange
        self.howItWorksButton.titleLabel?.font = UIFont.tgkNavigation
        
        self.storiesDividerView.backgroundColor = UIColor.tgkBackgroundGray
        self.story1Divider.backgroundColor = UIColor.tgkBackgroundGray
        self.story2Divider.backgroundColor = UIColor.tgkBackgroundGray
        
        self.storiesLabel.font = UIFont.tgkBody
        self.storiesLabel.textColor = UIColor.tgkLightGray
        
        self.story1Button.titleLabel?.font = UIFont.tgkNavigation
        self.story1Button.setTitleColor(UIColor.tgkOrange, for: .normal)
        self.story2Button.titleLabel?.font = UIFont.tgkNavigation
        self.story2Button.setTitleColor(UIColor.tgkOrange, for: .normal)
        self.story3Button.titleLabel?.font = UIFont.tgkNavigation
        self.story3Button.setTitleColor(UIColor.tgkOrange, for: .normal)
        
        self.feedbackDivider.backgroundColor = UIColor.tgkBackgroundGray
        
        self.feedbackLabel.font = UIFont.tgkBody
        self.feedbackLabel.textColor = UIColor.tgkLightGray
        
        self.feedbackDescriptionLabel.font = UIFont.tgkBody
        self.feedbackDescriptionLabel.textColor = UIColor.tgkGray
        
        self.feedbackDivider1.backgroundColor = UIColor.tgkLightGray
        self.feedbackDivider2.backgroundColor = UIColor.tgkLightGray
        self.feedbackDivider3.backgroundColor = UIColor.tgkLightGray
        
        self.feedbackPositiveButton.titleLabel?.font = UIFont.tgkNavigation
        self.feedbackPositiveButton.setTitleColor(UIColor.tgkOrange, for: .normal)
        self.feedbackNegativeButton.titleLabel?.font = UIFont.tgkNavigation
        self.feedbackNegativeButton.setTitleColor(UIColor.tgkOrange, for: .normal)
        self.feedbackProblemButton.titleLabel?.font = UIFont.tgkNavigation
        self.feedbackProblemButton.setTitleColor(UIColor.tgkOrange, for: .normal)
    }
    
    @IBAction func assistanceHowPressed(_ sender: Any) {
        
        guard let pdfUrl = Bundle.main.url(forResource: "GK Crisis Grants", withExtension: "pdf") else {
            return
        }
        let documentInteractionController = UIDocumentInteractionController(url: pdfUrl)
        documentInteractionController.delegate = self
        documentInteractionController.presentPreview(animated: true)
    }
    
    @IBAction func aboutStory1Pressed(_ sender: Any) {
        if let url = URL(string: "https://thegivingkitchen.org/reggie-ealy") {
            let safariVC = TGKSafariViewController(url: url)
            self.present(safariVC, animated: true)
        }
    }
    
    @IBAction func aboutStory2Pressed(_ sender: Any) {
        if let url = URL(string: "https://thegivingkitchen.org/when-irma-hit") {
            let safariVC = TGKSafariViewController(url: url)
            self.present(safariVC, animated: true)
        }
    }
    
    @IBAction func aboutStory3Pressed(_ sender: Any) {
        if let url = URL(string: "https://thegivingkitchen.org/shannon-brown-shares-her-story-in-athens") {
            let safariVC = TGKSafariViewController(url: url)
            self.present(safariVC, animated: true)
        }
    }
    
    @IBAction func feedbackNegativePressed(_ sender: Any) {
        let feedbackVC = FeedbackHomeViewController.feedbackViewControllerWithNavigation()
        self.tabBarController?.present(feedbackVC, animated: true)
    }
    
    @IBAction func feedbackProblemPressed(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
            let mailVC = MFMailComposeViewController()
            mailVC.mailComposeDelegate = self
            mailVC.setSubject("I'd like to report a problem with the GK App")
            mailVC.setToRecipients(["info@thegivingkitchen.org"])
            self.tabBarController?.present(mailVC, animated: true)
        }
    }
}

extension AboutHomeViewController:UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}

extension AboutHomeViewController:MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
