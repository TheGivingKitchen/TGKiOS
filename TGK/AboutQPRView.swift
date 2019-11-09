//
//  AboutQPRView.swift
//  TGK
//
//  Created by Jay Park on 11/9/19.
//  Copyright © 2019 TheGivingKitchen. All rights reserved.
//

import UIKit
protocol AboutQPRViewDelegate:class {
    func AboutQPRViewDelegateClosePressed() -> Void
    func AboutQPRViewDelegateTapped() -> Void
}
class AboutQPRView: BaseNibLoadedView {
    @IBOutlet weak var closeButton: UIButton!
    
    weak var delegate:AboutQPRViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.closeButton.setTemplateImage(named: "iconCloseX", for: .normal, tint: .black)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.closeButton.setTemplateImage(named: "iconCloseX", for: .normal, tint: .black)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func trainingButtonTapped(_ sender: Any) {
        self.delegate?.AboutQPRViewDelegateTapped()
    }
    
    @IBAction func closePressed(_ sender: Any) {
        self.delegate?.AboutQPRViewDelegateClosePressed()
    }
}
