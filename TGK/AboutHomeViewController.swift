//
//  AboutHomeViewController.swift
//  TGK
//
//  Created by Jay Park on 12/17/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import UIKit
import MessageUI
import Firebase
import StoreKit

class AboutHomeViewController: UITableViewController {
    
    @IBOutlet weak var topTitleLabel: UILabel!
    @IBOutlet weak var topTitleLabelDivider: UIView!
    @IBOutlet weak var aboutUsLabel: UILabel!
    @IBOutlet weak var assistanceDescriptionLabel: UILabel!
    @IBOutlet weak var howItWorksButton: UIButton!
    @IBOutlet weak var aboutUsDividerView: UIView!
    
    @IBOutlet weak var newsletterSignupButton: UIButton!
    @IBOutlet weak var newsletterSignupDivider: UIView!
    
    @IBOutlet weak var joinFacebookGroupLabel: UILabel!
    @IBOutlet weak var fbMetroAtlLabel: UILabel!
    @IBOutlet weak var fbNorthGaLabel: UILabel!
    @IBOutlet weak var fbSouthGaLabel: UILabel!
    @IBOutlet weak var fbGainesvilleLabel: UILabel!
    @IBOutlet weak var fbMaconLabel: UILabel!
    @IBOutlet weak var fbCoastalLabel: UILabel!
    @IBOutlet weak var fbAthensLabel: UILabel!
    @IBOutlet weak var fbColumbusLabel: UILabel!
    @IBOutlet weak var fbRomeLabel: UILabel!
    @IBOutlet weak var fbBottomDividerView: UIView!
    
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
    
    private var qprTrainingView:AboutQPRView!
    private var qprTrainingFormModel:SegmentedFormModel?
    private var qprViewBottomAnchor:NSLayoutConstraint!
    
    //Facebook Group Ids for deep linking
    private let fbDeepLinkBaseString = "fb://group?id="
    private let fbGroupUrlBaseString = "https://www.facebook.com/groups/"
    private let fbMetroGroupId = "1426736404312089"
    private let fbNorthGroupId = "1836033839791219"
    private let fbSouthGroupId = "1763853010365060"
    private let fbGainesvilleGroupId = "897787080404359"
    private let fbMaconGroupId = "218626942273765"
    private let fbCoastalGroupId = "197473227547650"
    private let fbAthensGroupId = "187999045361005"
    private let fbColumbusGroupId = "186740988816183"
    private let fbRomeGroupId = "182229385767905"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 400

        self.styleView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchFormsIfNeeded()
    }
    
    func setupQPRButton() {
        if AppDataStore.hasClosedQPRTrainingButton == true {
            return
        }
        if self.qprTrainingView != nil {
            return
        }
        
        self.qprTrainingView = AboutQPRView(frame: CGRect(x: 0, y: self.view.frame.maxY, width: 0, height: 0))
        self.qprTrainingView.delegate = self
        self.tableView.addSubview(self.qprTrainingView)
        
        self.qprTrainingView.trailingAnchor.constraint(equalTo: self.tableView.safeAreaLayoutGuide.trailingAnchor, constant: -16.0).isActive = true
        self.qprViewBottomAnchor = self.qprTrainingView.bottomAnchor.constraint(equalTo: self.tableView.safeAreaLayoutGuide.bottomAnchor, constant: 2000.0)
        self.qprViewBottomAnchor.isActive = true
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.qprViewBottomAnchor.constant = -16.0
            self.view.layoutIfNeeded()
        }) { (finished) in
        }
    }
    
    func fetchFormsIfNeeded() {
        if self.qprTrainingFormModel != nil {
            return
        }
        
        ServiceManager.sharedInstace.getFirebaseForm(id: "qprSignupForm") { (formModel, error) in
            if let formModel = formModel {
                self.qprTrainingFormModel = formModel
                self.setupQPRButton()
            }
        }
    }
    
    private func styleView() {
        self.topTitleLabel.font = UIFont.tgkContentSmallTitle
        self.topTitleLabel.textColor = UIColor.tgkOrange
        
        self.topTitleLabelDivider.backgroundColor = UIColor.tgkBackgroundGray
        
        self.aboutUsLabel.font = UIFont.tgkBody
        self.aboutUsLabel.textColor = UIColor.tgkLightGray
        self.aboutUsDividerView.backgroundColor = UIColor.tgkBackgroundGray
        
        self.newsletterSignupButton.titleLabel?.font = UIFont.tgkNavigation
        self.newsletterSignupButton.setTitleColor(UIColor.tgkOrange, for: .normal)
        self.newsletterSignupDivider.backgroundColor = UIColor.tgkBackgroundGray
        
        self.assistanceDescriptionLabel.font = UIFont.tgkBody
        self.assistanceDescriptionLabel.textColor = UIColor.tgkGray
        
        self.howItWorksButton.backgroundColor = UIColor.tgkOrange
        self.howItWorksButton.titleLabel?.font = UIFont.tgkNavigation
        
        self.joinFacebookGroupLabel.font = UIFont.tgkBody
        self.joinFacebookGroupLabel.textColor = UIColor.tgkGray
        
        self.fbMetroAtlLabel.font = UIFont.tgkBody
        self.fbMetroAtlLabel.textColor = UIColor.tgkBlue
        
        self.fbNorthGaLabel.font = UIFont.tgkBody
        self.fbNorthGaLabel.textColor = UIColor.tgkBlue
        
        self.fbSouthGaLabel.font = UIFont.tgkBody
        self.fbSouthGaLabel.textColor = UIColor.tgkBlue
        
        self.fbGainesvilleLabel.font = UIFont.tgkBody
        self.fbGainesvilleLabel.textColor = UIColor.tgkBlue
        
        self.fbMaconLabel.font = UIFont.tgkBody
        self.fbMaconLabel.textColor = UIColor.tgkBlue
        
        self.fbCoastalLabel.font = UIFont.tgkBody
        self.fbCoastalLabel.textColor = UIColor.tgkBlue
        
        self.fbAthensLabel.font = UIFont.tgkBody
        self.fbAthensLabel.textColor = UIColor.tgkBlue
        
        self.fbColumbusLabel.font = UIFont.tgkBody
        self.fbColumbusLabel.textColor = UIColor.tgkBlue
        
        self.fbRomeLabel.font = UIFont.tgkBody
        self.fbRomeLabel.textColor = UIColor.tgkBlue
        
        self.fbBottomDividerView.backgroundColor = UIColor.tgkBackgroundGray
        
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
        
        Analytics.logEvent(customName: .learnMorePressed, parameters: [.learnMoreType:"crisis_grant_info_graphic"])
    }
    
    @IBAction func newsletterSignupButtonPressed(_ sender: Any) {
        if let url = URL(string: "https://thegivingkitchen.us3.list-manage.com/subscribe?u=8ce234d2bdddfb2c1ba574d4f&id=9071a9bab9") {
            let safariVC = TGKSafariViewController(url: url)
            self.present(safariVC, animated: true)
            
            Analytics.logEvent(customName: .newsletterSignupStarted)
        }
    }
    
    //MARK: Facebook group button actions
    @IBAction func metroGroupPressed(_ sender: Any) {
        self.open(groupId: self.fbMetroGroupId, analyticsName: "metro_atlanta")
    }
    
    @IBAction func northGroupPressed(_ sender: Any) {
        self.open(groupId: self.fbNorthGroupId, analyticsName: "north_ga")
    }
    
    @IBAction func southGroupPressed(_ sender: Any) {
        self.open(groupId: self.fbSouthGroupId, analyticsName: "south_ga")
    }
    @IBAction func gainesvilleGroupPressed(_ sender: Any) {
        self.open(groupId: self.fbGainesvilleGroupId, analyticsName: "gainesville_ga")
    }
    @IBAction func maconGroupPressed(_ sender: Any) {
        self.open(groupId: self.fbMaconGroupId, analyticsName: "macon_ga")
    }
    @IBAction func coastalGroupPressed(_ sender: Any) {
        self.open(groupId: self.fbCoastalGroupId, analyticsName: "coastal_ga")
    }
    @IBAction func athensGroupPressed(_ sender: Any) {
        self.open(groupId: self.fbAthensGroupId, analyticsName: "athens_ga")
    }
    @IBAction func columbusGroupPressed(_ sender: Any) {
        self.open(groupId: self.fbColumbusGroupId, analyticsName: "columbus_ga")
    }
    @IBAction func romeGroupPressed(_ sender: Any) {
        self.open(groupId: self.fbRomeGroupId, analyticsName: "rome_ga")
    }
    
    fileprivate func open(groupId:String, analyticsName:String) {
        
        guard let deepLinkUrl = URL(string: self.fbDeepLinkBaseString + groupId),
            let webUrl = URL(string: self.fbGroupUrlBaseString + groupId) else {
                return
        }
        
        if UIApplication.shared.canOpenURL(deepLinkUrl) {
            UIApplication.shared.open(deepLinkUrl, options: [:]) { (success) in
            }
        }
        else {
            let tgkSafariVC = TGKSafariViewController(url: webUrl)
            self.present(tgkSafariVC, animated: true)
        }
        
        Analytics.logEvent(customName: .safetyNetFacebookGroupVisit, parameters: [.safetyNetFacebookGroupName:analyticsName])
    }
    
    //MARK: Story button actions
    @IBAction func aboutStory1Pressed(_ sender: Any) {
        if let url = URL(string: "https://thegivingkitchen.org/reggie-ealy") {
            let safariVC = TGKSafariViewController(url: url)
            self.present(safariVC, animated: true)
        }
        
        Analytics.logEvent(customName: .learnMorePressed, parameters: [.learnMoreType:"story_the_performer"])
    }
    
    @IBAction func aboutStory2Pressed(_ sender: Any) {
        if let url = URL(string: "https://thegivingkitchen.org/lets-talk-about-it") {
            let safariVC = TGKSafariViewController(url: url)
            self.present(safariVC, animated: true)
            
            Analytics.logEvent(customName: .learnMorePressed, parameters: [.learnMoreType:"lets_talk_about_it"])
        }
    }
    
    @IBAction func aboutStory3Pressed(_ sender: Any) {
        if let url = URL(string: "https://thegivingkitchen.org/why-qpr") {
            let safariVC = TGKSafariViewController(url: url)
            self.present(safariVC, animated: true)
            
            Analytics.logEvent(customName: .learnMorePressed, parameters: [.learnMoreType:"why_qpr"])
        }
    }
    
    @IBAction func feedbackPositivePressed(_ sender: Any) {
        let reviewWarmer = StoreReviewWarmerViewController.instantiateWith(delegate: self)
        self.tabBarController?.present(reviewWarmer, animated: true)
        
        Analytics.logEvent(customName: .feedbackPositive)
    }
    
    @IBAction func feedbackNegativePressed(_ sender: Any) {
        let feedbackVC = FeedbackHomeViewController.feedbackViewControllerWithNavigation()
        self.tabBarController?.present(feedbackVC, animated: true)
        
        Analytics.logEvent(customName: .feedbackComment)
    }
    
    @IBAction func feedbackProblemPressed(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
            let mailVC = MFMailComposeViewController()
            mailVC.mailComposeDelegate = self
            mailVC.setSubject("I'd like to report a problem with the GK App")
            mailVC.setToRecipients(["info@thegivingkitchen.org"])
            self.tabBarController?.present(mailVC, animated: true)
            
            Analytics.logEvent(customName: .feedbackReportProblem)
        }
    }
}

//MARK: uitableview overrides for static table
extension AboutHomeViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
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

extension AboutHomeViewController:StoreReviewWarmerViewControllerDelegate {
    func storeReviewWarmerViewControllerDidAccept(viewController: StoreReviewWarmerViewController) {
        viewController.dismiss(animated: false) {
            DispatchQueue.main.async {
                SKStoreReviewController.requestReview()
            }
        }
    }
    
    func storeReviewWarmerViewControllerDidDecline(viewController: StoreReviewWarmerViewController) {
        viewController.dismiss(animated: true)
    }
}

extension AboutHomeViewController:AboutQPRViewDelegate {
    func AboutQPRViewDelegateClosePressed() {
        self.dismissQPRView()
    }
    
    func AboutQPRViewDelegateTapped() {
        guard let trainingForm = self.qprTrainingFormModel else {
            return
        }
        
        let segmentedNav = UIStoryboard(name: "Forms", bundle: nil).instantiateViewController(withIdentifier: "SegmentedFormNavigationControllerId") as! SegmentedFormNavigationController
        segmentedNav.segmentedFormModel = trainingForm
        segmentedNav.formDelegate = self
        self.present(segmentedNav, animated: true)
    }
    
    func dismissQPRView() {
        AppDataStore.hasClosedQPRTrainingButton = true
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            self.qprViewBottomAnchor.constant = self.view.frame.height
            self.view.layoutIfNeeded()
        }) { (finished) in
            self.qprTrainingView.isHidden = true
        }
    }
}

//MARK: Segmented Form Delegate
extension AboutHomeViewController:SegmentedFormNavigationControllerDelegate {
    //the only form we're tracking here is QPR training signup
    func segmentedFormNavigationControllerDidFinish(viewController: SegmentedFormNavigationController) {
        self.dismissQPRView()
        
        viewController.dismiss(animated: true) {
            let successVC = AssistanceSuccessViewController.assistanceSuccessViewController(withDelegate: self)
            self.present(successVC, animated:true)
        }
    }
}

//MARK: AssistanceSuccessViewControllerDelegate
extension AboutHomeViewController:AssistanceSuccessViewControllerDelegate {
    func assistanceSuccessViewControllerDelegateDonePressed(viewController: AssistanceSuccessViewController) {
        viewController.dismiss(animated: true)
    }
}
