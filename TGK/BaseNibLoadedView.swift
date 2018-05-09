//
//  BaseNibLoadedView.swift
//  TGK
//
//  Created by Jay Park on 5/8/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import UIKit

@IBDesignable
class BaseNibLoadedView: UIView {
    
    @IBOutlet weak var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.nibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.nibSetup()
    }
    
    private func nibSetup() {
        self.backgroundColor = .clear
        
        self.view = self.loadViewFromNib()
        self.view.frame = self.bounds
        self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.translatesAutoresizingMaskIntoConstraints = true
        
        self.addSubview(view)
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return nibView
    }
    
}
