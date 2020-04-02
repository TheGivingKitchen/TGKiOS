//
//  StabilityNetOnboardingViewController.swift
//  TGK
//
//  Created by Jay Park on 3/29/20.
//  Copyright © 2020 TheGivingKitchen. All rights reserved.
//

import Foundation
import UIKit

class StabilityNetOnboardingViewController:UIViewController {
    
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var programDescriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.styleView()
    }
    
    private func styleView() {
        self.view.backgroundColor = UIColor.tgkDarkGray
        self.view.backgroundColor = self.view.backgroundColor?.withAlphaComponent(0.45)
        
        self.mainTitleLabel.font = UIFont.tgkContentSmallTitle
        self.mainTitleLabel.textColor = UIColor.tgkOrange
        
        self.programDescriptionLabel.font = UIFont.tgkBody
        self.programDescriptionLabel.textColor = UIColor.tgkBlue
        
        self.doneButton.titleLabel?.font = UIFont.tgkNavigation
        self.doneButton.backgroundColor = UIColor.tgkOrange
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        AppDataStore.hasClosedStabilityNetOnboarding = true
        self.dismiss(animated: true)
    }
    
}
