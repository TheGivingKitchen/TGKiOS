//
//  StoreReviewWarmerViewController.swift
//  TGK
//
//  Created by Jay Park on 1/1/19.
//  Copyright © 2019 TheGivingKitchen. All rights reserved.
//

import UIKit

protocol StoreReviewWarmerViewControllerDelegate:class {
    func storeReviewWarmerViewControllerDidAccept(viewController:StoreReviewWarmerViewController)
    func storeReviewWarmerViewControllerDidDecline(viewController:StoreReviewWarmerViewController)
}

class StoreReviewWarmerViewController: UIViewController {
    
    @IBOutlet weak var innerContentView: UIView!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    weak var delegate:StoreReviewWarmerViewControllerDelegate?

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
        self.delegate?.storeReviewWarmerViewControllerDidAccept(viewController: self)
    }
    
    @IBAction func declinePressed(_ sender: Any) {
        self.delegate?.storeReviewWarmerViewControllerDidDecline(viewController: self)
    }
}

//MARK: convenience initializer
extension StoreReviewWarmerViewController {
    static func instantiateWith(delegate: StoreReviewWarmerViewControllerDelegate) -> StoreReviewWarmerViewController {
        let reviewWarmerModal = UIStoryboard(name: "Feedback", bundle: nil).instantiateViewController(withIdentifier: "StoreReviewWarmerViewControllerId") as! StoreReviewWarmerViewController
        reviewWarmerModal.modalPresentationStyle = .overCurrentContext
        reviewWarmerModal.delegate = delegate
        return reviewWarmerModal
    }


}
