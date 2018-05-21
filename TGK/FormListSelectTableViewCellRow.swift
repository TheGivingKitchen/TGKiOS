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
    @IBOutlet weak var innerSelectionView: UIView!
    
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
        //style
        self.choiceLabel.font = UIFont.tgkBody
        self.choiceLabel.textColor = UIColor.tgkNavy
        self.innerSelectionView.layer.borderWidth = 1
        self.innerSelectionView.layer.borderColor = UIColor.tgkNavy.cgColor
        self.innerSelectionView.backgroundColor = UIColor.white
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped(recognizer:)))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func updateViewForSelection() {
        if self.isSelected {
            self.innerSelectionView.backgroundColor = UIColor.tgkNavy
            self.choiceLabel.textColor = UIColor.white
        }
        else {
            self.innerSelectionView.backgroundColor = UIColor.white
            self.choiceLabel.textColor = UIColor.tgkNavy
        }
    }
    
}
