//
//  AssistanceSuccessViewController.swift
//  TGK
//
//  Created by Jay Park on 8/6/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import UIKit

protocol AssistanceSuccessViewControllerDelegate:class {
    func assistanceSuccessViewControllerDelegateDonePressed(viewController:AssistanceSuccessViewController)
}

class AssistanceSuccessViewController: UIViewController {

    @IBOutlet weak var thankYouLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    weak var delegate:AssistanceSuccessViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.styleView()
    }

    func styleView() {
        self.thankYouLabel.font = UIFont.tgkContentSmallTitle
        self.thankYouLabel.textColor = UIColor.tgkOrange
        
        self.bodyLabel.font = UIFont.tgkBody
        self.bodyLabel.textColor = UIColor.darkGray
        
        self.doneButton.backgroundColor = UIColor.tgkOrange
        self.doneButton.titleLabel?.font = UIFont.tgkBody
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        self.delegate?.assistanceSuccessViewControllerDelegateDonePressed(viewController: self)
    }
}

extension AssistanceSuccessViewController {
    static func assistanceSuccessViewController(withDelegate delegate:AssistanceSuccessViewControllerDelegate) -> AssistanceSuccessViewController {
        let assistanceSuccessVC = UIStoryboard(name: "Assistance", bundle: nil).instantiateViewController(withIdentifier: "AssistanceSuccessViewControllerId") as! AssistanceSuccessViewController
        assistanceSuccessVC.delegate = delegate
        return assistanceSuccessVC
    }
}
