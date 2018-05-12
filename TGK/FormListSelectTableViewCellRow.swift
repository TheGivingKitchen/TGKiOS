//
//  FormListSelectTableViewCellRow.swift
//  TGK
//
//  Created by Jay Park on 5/8/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import Foundation
import UIKit

protocol FormListSelectTableViewCellRowDelegate {
    func formListSelectTableViewCellRowWasSelected(cell:FormListSelectTableViewCellRow)
    //Could possibily implement deselected if we want different behaviors
}

class FormListSelectTableViewCellRow:BaseNibLoadedView {
    
    @IBOutlet weak var choiceLabel: UILabel!
    
    var delegate:FormListSelectTableViewCellRowDelegate?
    
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
        
        self.delegate?.formListSelectTableViewCellRowWasSelected(cell: self)
    }
    
    private func configureView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped(recognizer:)))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func updateViewForSelection() {
        if self.isSelected {
            self.view.backgroundColor = UIColor.tgkBlue
            self.choiceLabel.textColor = UIColor.white
        }
        else {
            self.view.backgroundColor = UIColor.white
            self.choiceLabel.textColor = UIColor.black
        }
    }
    
}
