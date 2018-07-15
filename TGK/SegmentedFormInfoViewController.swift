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
    @IBOutlet weak var dividerView: UIView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var shareFormLabel: UILabel!
    @IBOutlet weak var formInfoScrollView: UIScrollView!
    @IBOutlet weak var formCallToActionBackgroundView: UIView!
    
    //Used to restore navigation bar elements
    fileprivate var previousNavigationShadowImage:UIImage?
    fileprivate var previousNavigationBarTintColor:UIColor?
    fileprivate var previousNavigationBackgroundImage:UIImage?
    
    var segmentedFormModel:SegmentedFormModel! {
        didSet {
            guard self.isViewLoaded else {return}
            self.configureView()
        }
    }
    
    weak var delegate:SegmentedFormInfoViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.styleView()
        self.configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.styleNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.resetNavigationBar()
    }
    
    private func styleNavigationBar() {
        if let navigationController = self.navigationController {
            navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController.navigationBar.shadowImage = UIImage()
            navigationController.navigationBar.barTintColor = UIColor.tgkBeige
        }
    }
    
    private func resetNavigationBar() {
        if let navigationController = self.navigationController {
            navigationController.navigationBar.setBackgroundImage(self.previousNavigationBackgroundImage, for: .default)
            navigationController.navigationBar.shadowImage = self.previousNavigationShadowImage
            navigationController.navigationBar.barTintColor = self.previousNavigationBarTintColor
        }
    }
    
    private func styleView() {
        self.formInfoScrollView.backgroundColor = UIColor.tgkBeige
        self.formCallToActionBackgroundView.backgroundColor = UIColor.tgkBeige
        self.dividerView.backgroundColor = UIColor.tgkLightGray
        
        self.formTitle.font = UIFont.tgkContentTitle
        self.formTitle.textColor = UIColor.tgkOrange
        
        self.formSubtitle.font = UIFont.tgkSubtitle
        self.formSubtitle.textColor = UIColor.tgkBlue
        
        
        self.formMetadata.font = UIFont.tgkMetadata
        self.formMetadata.textColor = UIColor.tgkDarkDarkGray
        
        self.continueButton.backgroundColor = UIColor.tgkOrange
        self.continueButton.tintColor = UIColor.white
        self.continueButton.setAttributedTitle(NSAttributedString(string: "Start", attributes: [.font:UIFont.tgkNavigation]), for: .normal)
        
        self.shareFormLabel.font = UIFont.tgkBody
        self.shareFormLabel.textColor = UIColor.tgkLightGray
    }
    
    private func configureView() {
        guard self.segmentedFormModel != nil else {
            return
        }
        
        self.formTitle.text = self.segmentedFormModel.title
        
        self.formSubtitle.text = self.segmentedFormModel.subtitle
        
        self.formMetadata.text = self.segmentedFormModel.metadata
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
