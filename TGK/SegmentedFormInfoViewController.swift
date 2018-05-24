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
}

class SegmentedFormInfoViewController: UIViewController {

    @IBOutlet weak var formTitle: UILabel!
    @IBOutlet weak var formSubtitle: UILabel!
    @IBOutlet weak var formMetadata: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    var segmentedFormModel:SegmentedFormModel! {
        didSet {
            self.configureView()
        }
    }
    
    weak var delegate:SegmentedFormInfoViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    private func configureView() {
        
    }
    
    @IBAction func continuePressed(_ sender: Any) {
        self.delegate?.segmentedFormInfoViewControllerDidPressContinue(segmentedFormInfoViewController: self)
    }
    
    @IBAction func sharePressed(_ sender: Any) {
    }
}
