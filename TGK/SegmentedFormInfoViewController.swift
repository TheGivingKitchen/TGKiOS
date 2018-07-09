//
//  SegmentedFormInfoViewController.swift
//  TGK
//
//  Created by Jay Park on 5/23/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import UIKit

protocol SegmentedFormInfoViewControllerDelegate:class {
    func segmentedFormInfoViewControllerDidPressContinue(segmentedFormInfoViewController:SegmentedFormInfoViewController)
    func segmentedFormInfoViewControllerDidPressCancel(segmentedFormInfoViewController:SegmentedFormInfoViewController)
}

class SegmentedFormInfoViewController: UIViewController {

    @IBOutlet weak var formTitle: UILabel!
    @IBOutlet weak var formSubtitle: UILabel!
    @IBOutlet weak var formMetadata: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var formInfoBackgroundView: UIView!
    @IBOutlet weak var formCallToActionBackgroundView: UIView!
    @IBOutlet weak var formInfoDividerView: UIView!
    
    var segmentedFormModel:SegmentedFormModel! {
        didSet {
            guard self.isViewLoaded else {return}
            self.configureView()
        }
    }
    
    weak var delegate:SegmentedFormInfoViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    private func configureView() {
        self.formInfoBackgroundView.backgroundColor = UIColor.tgkBeige
        self.formInfoDividerView.backgroundColor = UIColor.tgkBackgroundGray
        
        self.formTitle.font = UIFont.tgkContentTitle
        self.formTitle.text = self.segmentedFormModel.title
        self.formTitle.textColor = UIColor.tgkOrange
        
        self.formSubtitle.text = self.segmentedFormModel.subtitle
        self.formSubtitle.font = UIFont.tgkSubtitle
        self.formSubtitle.textColor = UIColor.tgkBlue
        
        self.formMetadata.text = self.segmentedFormModel.metadata
        self.formMetadata.font = UIFont.tgkMetadata
        self.formMetadata.textColor = UIColor.tgkDarkDarkGray
        
        self.continueButton.backgroundColor = UIColor.tgkOrange
        self.continueButton.tintColor = UIColor.white
        self.continueButton.setAttributedTitle(NSAttributedString(string: "Continue", attributes: [.font:UIFont.tgkBody]), for: .normal)

        self.shareButton.tintColor = UIColor.tgkOrange
        self.shareButton.setAttributedTitle(NSAttributedString(string: "Share link to this form", attributes: [.font:UIFont.tgkBody]), for: .normal)
    }
    
    @IBAction func continuePressed(_ sender: Any) {
        self.delegate?.segmentedFormInfoViewControllerDidPressContinue(segmentedFormInfoViewController: self)
    }
    @IBAction func cancelPressed(_ sender: Any) {
        self.delegate?.segmentedFormInfoViewControllerDidPressCancel(segmentedFormInfoViewController: self)
    }
    
    @IBAction func sharePressed(_ sender: Any) {
        ExternalShareManager.sharedInstance.presentShareControllerFromViewController(fromController: self, title: "Sign up to be a Giving Kitchen Volunteer", urlString: segmentedFormModel.shareFormUrlString, image: UIImage(named: "tgkShareIcon"))
    }
}
