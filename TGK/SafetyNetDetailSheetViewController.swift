//
//  SafetyNetDetailSheetViewController.swift
//  TGK
//
//  Created by Jay Park on 12/16/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import UIKit
import Firebase

class SafetyNetDetailSheetViewController: UIViewController {
    
    @IBOutlet weak var innerSheetView: UIView!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var businessContactInfoLabel: UILabel!
    @IBOutlet weak var websiteButton: UIButton!
    @IBOutlet weak var directionsButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var countiesLabel: UILabel!
    
    @IBOutlet weak var websiteStackView: UIStackView!
    @IBOutlet weak var directionsStackView: UIStackView!
    @IBOutlet weak var callStackView: UIStackView!
    
    @IBOutlet weak var dividerView1: UIView!
    @IBOutlet weak var dividerView2: UIView!
    @IBOutlet weak var dividerView3: UIView!
    @IBOutlet weak var dividerView4: UIView!
    
    
    //Dependencies
    var safetyNetModel:SafetyNetResourceModel! {
        didSet {
            guard isViewLoaded else {
                return
            }
            self.configureView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        
        self.styleView()
        self.configureView()
        
        let tapGestureRec = UITapGestureRecognizer(target: self, action: #selector(topNegativeAreaTapped))
        self.view.addGestureRecognizer(tapGestureRec)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.backgroundColor = UIColor.tgkDarkGray.withAlphaComponent(0.45)
        }) { (finished) in
            self.view.backgroundColor = UIColor.tgkDarkGray.withAlphaComponent(0.45)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.backgroundColor = UIColor.clear
    }
    
    @objc func topNegativeAreaTapped() {
        self.dismiss(animated: true)
    }
    
    private func styleView() {
        self.innerSheetView.layer.cornerRadius = 20
        self.innerSheetView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        self.businessNameLabel.font = UIFont.tgkSubtitle
        self.businessNameLabel.textColor = UIColor.tgkBlue
        
        self.dividerView1.backgroundColor = UIColor.tgkLightGray
        self.dividerView2.backgroundColor = UIColor.tgkLightGray
        self.dividerView3.backgroundColor = UIColor.tgkLightGray
        self.dividerView4.backgroundColor = UIColor.tgkLightGray
        
        self.categoryLabel.font = UIFont.tgkBody
        self.categoryLabel.textColor = UIColor.tgkOrange
        
        self.descriptionLabel.font = UIFont.tgkBody
        self.descriptionLabel.textColor = UIColor.tgkDarkDarkGray
        
        self.businessContactInfoLabel.font = UIFont.tgkBody
        self.businessContactInfoLabel.textColor = UIColor.tgkGray
        
        self.websiteButton.setTitleColor(UIColor.tgkOrange, for: .normal)
        self.websiteButton.titleLabel?.font = UIFont.tgkNavigation
        
        self.directionsButton.setTitleColor(UIColor.tgkOrange, for: .normal)
        self.directionsButton.titleLabel?.font = UIFont.tgkNavigation
        
        self.callButton.setTitleColor(UIColor.tgkOrange, for: .normal)
        self.callButton.titleLabel?.font = UIFont.tgkNavigation
        
        self.countiesLabel.font = UIFont.tgkBody
        self.countiesLabel.textColor = UIColor.tgkGray
    }
    
    fileprivate func configureView() {
        self.businessNameLabel.text = self.safetyNetModel.name
        self.categoryLabel.text = self.safetyNetModel.category
        self.descriptionLabel.text = self.safetyNetModel.resourceDescription
        
        var businessInfo:[String] = []
        if let websiteString = safetyNetModel.websiteUrl?.absoluteString {
            businessInfo.append(websiteString)
        }
        if let addressString = safetyNetModel.address {
            businessInfo.append(addressString)
        }
        if let phoneString = safetyNetModel.phoneNumber {
            businessInfo.append(phoneString)
        }
        if let contactPersonString = safetyNetModel.contactName {
            businessInfo.append("Ask for \(contactPersonString)")
        }
        let businessInfoString = businessInfo.count > 0 ? businessInfo.joined(separator: "\n") : nil
        self.businessContactInfoLabel.text = businessInfoString
        
        if safetyNetModel.websiteUrl == nil {
            self.websiteStackView.isHidden = true
        }
        if safetyNetModel.address.isNilOrEmpty {
            self.directionsStackView.isHidden = true
        }
        if safetyNetModel.phoneNumber.isNilOrEmpty {
            self.callStackView.isHidden = true
        }
        
        if self.safetyNetModel.isNationwide {
            self.countiesLabel.text = "This is a nationwide resource"
        }
        else if self.safetyNetModel.isStatewide,
            let state = self.safetyNetModel.state {
            self.countiesLabel.text = "Serves all of \(state)"
        }
        else if let countiesArray = self.safetyNetModel.counties {
            self.countiesLabel.text = "Serves \(countiesArray.joined(separator: ", "))"
        }
        else {
            self.countiesLabel.text = nil
        }
    }
    
    @IBAction func websiteButtonPressed(_ sender: Any) {
        if let model = self.safetyNetModel,
            let url = model.websiteUrl {
            let webviewVC = TGKSafariViewController(url: url)
            self.present(webviewVC, animated:true)
            
            Analytics.logEvent(customName: .safetyNetVisitWebsite, parameters: [.safetyNetName:model.name])
        }
    }
    
    @IBAction func directionsButtonPressed(_ sender: Any) {
        if let model = self.safetyNetModel,
            let address = self.safetyNetModel?.address {
            let formattedAddressString = address.replacingOccurrences(of: " ", with: "+")
            
            if let googleDeepLinkUrl = URL(string:"comgooglemapsurl://?daddr=\(formattedAddressString)"),
                UIApplication.shared.canOpenURL(googleDeepLinkUrl) {
                
                let alertController = UIAlertController(title: "Open in", message: nil, preferredStyle: .actionSheet)
                let googleMapAction = UIAlertAction(title: "Google Maps", style: .default) { (action) in
                    UIApplication.shared.open(googleDeepLinkUrl, options: [:])
                }
                alertController.addAction(googleMapAction)
                
                let appleMapAction = UIAlertAction(title: "Apple Maps", style: .default) { (action) in
                    if let appleMapsUrl = URL(string: "http://maps.apple.com/?address=\(formattedAddressString)") {
                        UIApplication.shared.open(appleMapsUrl, options: [:])
                    }
                }
                alertController.addAction(appleMapAction)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                    self.dismiss(animated: true)
                }
                alertController.addAction(cancelAction)
                
                alertController.view.tintColor = UIColor.tgkBlue
                self.present(alertController, animated: true)
            }
            else if let appleMapsUrl = URL(string: "http://maps.apple.com/?address=\(formattedAddressString)") {
                UIApplication.shared.open(appleMapsUrl, options: [:])
            }
            
            Analytics.logEvent(customName: .safetyNetVisitAddress, parameters: [.safetyNetName:model.name])
        }
    }
    
    @IBAction func callButtonPressed(_ sender: Any) {
        if let model = self.safetyNetModel,
            let phoneNumber = self.safetyNetModel?.phoneNumber,
            let phoneUrl = URL(string: "tel://\(phoneNumber.formatStringToNumericString())") {
            UIApplication.shared.open(phoneUrl, options: [:]) { (success) in
            }
            
            Analytics.logEvent(customName: .safetyNetCallPhone, parameters: [.safetyNetName:model.name])
        }
    }
    
}

//MARK: convenience initializer
extension SafetyNetDetailSheetViewController {
    static func instantiateWith(safetyNetResource:SafetyNetResourceModel) -> UINavigationController {
        let detailSheet = UIStoryboard(name: "SafetyNet", bundle: nil).instantiateViewController(withIdentifier: "SafetyNetDetailSheetViewControllerId") as! SafetyNetDetailSheetViewController
        detailSheet.safetyNetModel = safetyNetResource
        let navController = UINavigationController(rootViewController: detailSheet)
        navController.view.backgroundColor = UIColor.clear
        navController.navigationBar.isHidden = true
        navController.modalPresentationStyle = .overCurrentContext
        
        return navController
    }
}
