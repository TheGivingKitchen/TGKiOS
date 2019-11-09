//
//  AboutQPRView.swift
//  TGK
//
//  Created by Jay Park on 11/9/19.
//  Copyright © 2019 TheGivingKitchen. All rights reserved.
//

import UIKit

class AboutQPRView: BaseNibLoadedView {
    @IBOutlet weak var closeButton: UIButton!
    
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
    
    @IBAction func closePressed(_ sender: Any) {
        ///Doing this all the short and sloppy way, likely to be removed in later version  
        AppDataStore.hasClosedQPRTrainingButton = true
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            self.frame = CGRect(x: self.frame.minX, y: UIScreen.main.bounds.height, width: self.frame.width, height: self.frame.height)
        }) { (finished) in
            self.isHidden = true
        }
    }
}
