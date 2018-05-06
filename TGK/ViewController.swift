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
        ServiceManager.sharedInstace.getForm(id: "w1t7006405irhin") { (formQuestionModels, error) in
        
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func assistanceTapped(_ sender: Any) {
        let segmentedNav = UIStoryboard(name: "Forms", bundle: nil).instantiateViewController(withIdentifier: "SegmentedFormNavigationControllerId") as! SegmentedFormNavigationController
        self.present(segmentedNav, animated: true)
    }
    
}

