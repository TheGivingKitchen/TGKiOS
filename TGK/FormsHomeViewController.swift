//
//  FormsHomeViewController.swift
//  TGK
//
//  Created by Jay Park on 5/20/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import UIKit

class FormsHomeViewController: UIViewController {

    @IBOutlet weak var assistanceButton: UIButton!
    @IBOutlet weak var volunteerButton: UIButton!
    
    var assistanceFormModel:SegmentedFormModel!
    var volunteerFormModel:SegmentedFormModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.assistanceButton.isHidden = true
        self.volunteerButton.isHidden = true
        
        ServiceManager.sharedInstace.getFirebaseForm(id: "z1a0tap91any17q") { (formModel, error) in
            if let formModel = formModel {
                self.assistanceFormModel = formModel
                self.assistanceButton.isHidden = false
            }
        }
        
        ServiceManager.sharedInstace.getFirebaseForm(id: "zl0n8dd0u0hk0z") { (formModel, error) in
            if let formModel = formModel {
                self.volunteerFormModel = formModel
                self.volunteerButton.isHidden = false
            }
        }
        
    }
    
    @IBAction func assistanceTapped(_ sender: Any) {
        
        let segmentedNav = UIStoryboard(name: "Forms", bundle: nil).instantiateViewController(withIdentifier: "SegmentedFormNavigationControllerId") as! SegmentedFormNavigationController
        segmentedNav.segmentedFormModel = assistanceFormModel
        self.present(segmentedNav, animated: true)
    }
    
    @IBAction func volunteerSignUpTapped(_ sender: Any) {
        
        let segmentedNav = UIStoryboard(name: "Forms", bundle: nil).instantiateViewController(withIdentifier: "SegmentedFormNavigationControllerId") as! SegmentedFormNavigationController
        segmentedNav.segmentedFormModel = volunteerFormModel
        self.present(segmentedNav, animated: true)
    }
}
