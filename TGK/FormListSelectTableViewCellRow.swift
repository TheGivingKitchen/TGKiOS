//
//  FormListSelectTableViewCellRow.swift
//  TGK
//
//  Created by Jay Park on 5/8/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import Foundation
import UIKit

class FormListSelectTableViewCellRow:BaseNibLoadedView {
    
    @IBOutlet weak var choiceLabel: UILabel!
    
    var isSelected:Bool = false {
        didSet {
            self.updateViewForSelection()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.configureView()
    }
    
    
    @objc func viewTapped(recognizer:UITapGestureRecognizer) {
        self.isSelected = !self.isSelected
    }
    
    private func configureView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped(recognizer:)))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        
    }
    
    private func updateViewForSelection() {
        if self.isSelected {
            self.view.backgroundColor = UIColor.tgkBlue
        }
        else {
            self.view.backgroundColor = UIColor.white
        }
    }
    
}
