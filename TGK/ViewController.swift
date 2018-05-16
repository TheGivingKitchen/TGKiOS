//
//  ViewController.swift
//  TGK
//
//  Created by Jay Park on 5/4/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func assistanceTapped(_ sender: Any) {
        ServiceManager.sharedInstace.getLocalFormWith(id: "z1a0tap91any17q") { (segmentedFormModel, error) in
            let segmentedNav = UIStoryboard(name: "Forms", bundle: nil).instantiateViewController(withIdentifier: "SegmentedFormNavigationControllerId") as! SegmentedFormNavigationController
            segmentedNav.segmentedFormModel = segmentedFormModel
            self.present(segmentedNav, animated: true)
        }
        
    }
    
    @IBAction func volunteerSignUpTapped(_ sender: Any) {
        ServiceManager.sharedInstace.getLocalFormWith(id: "zl0n8dd0u0hk0z") { (segmentedFormModel, error) in
            let segmentedNav = UIStoryboard(name: "Forms", bundle: nil).instantiateViewController(withIdentifier: "SegmentedFormNavigationControllerId") as! SegmentedFormNavigationController
            segmentedNav.segmentedFormModel = segmentedFormModel
            self.present(segmentedNav, animated: true)
        }
    }
}

