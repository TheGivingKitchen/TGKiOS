//
//  LocationWarmingViewController.swift
//  TGK
//
//  Created by Jay Park on 9/11/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import UIKit

protocol LocationWarmingViewControllerDelegate:class {
    func locationWarmingViewControllerDidAccept(viewController:LocationWarmingViewController)
    func locationWarmingViewControllerDidDecline(viewController:LocationWarmingViewController)
}

class LocationWarmingViewController: UIViewController {

    @IBOutlet weak var innerContentView: UIView!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    weak var delegate:LocationWarmingViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.styleView()
    }
    
    private func styleView() {
        self.view.backgroundColor = UIColor.clear
        
        self.innerContentView.layer.cornerRadius = 5
        self.innerContentView.layer.borderWidth = 1
        self.innerContentView.layer.borderColor = UIColor.tgkLightGray.cgColor
        
        self.titleLabel.font = UIFont.tgkContentSmallTitle
        self.titleLabel.textColor = UIColor.tgkOrange
        
        self.descriptionLabel.font = UIFont.tgkBody
        self.descriptionLabel.textColor = UIColor.tgkBlue
        
        self.acceptButton.backgroundColor = UIColor.tgkOrange
        self.acceptButton.titleLabel?.font = UIFont.tgkNavigation
        
        self.declineButton.tintColor = UIColor.tgkGray
        self.declineButton.titleLabel?.font = UIFont.tgkNavigation
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

    
    @IBAction func acceptPressed(_ sender: Any) {
        self.delegate?.locationWarmingViewControllerDidAccept(viewController: self)
    }

    @IBAction func declinePressed(_ sender: Any) {
        self.delegate?.locationWarmingViewControllerDidDecline(viewController: self)
    }
}

//MARK: convenience initializer
extension LocationWarmingViewController {
    static func instantiateWith(delegate: LocationWarmingViewControllerDelegate) -> LocationWarmingViewController {
        let locationModal = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LocationWarmingViewControllerId") as! LocationWarmingViewController
        locationModal.modalPresentationStyle = .overCurrentContext
        locationModal.delegate = delegate
        return locationModal
    }
}
