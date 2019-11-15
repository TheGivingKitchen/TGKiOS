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
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var qprImageView: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    
    weak var delegate:AboutQPRViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    private func commonInit() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.textLabel.font = UIFont.kulturistaBold(size: 22.0)
        self.textLabel.textColor = UIColor.tgkDarkBlue
        
        self.closeButton.tintColor = UIColor.tgkDarkDarkGray
        self.closeButton.titleLabel?.font = UIFont.kulturistaMedium(size: 20)
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
