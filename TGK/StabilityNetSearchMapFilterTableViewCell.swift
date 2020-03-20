//
//  StabilityNetSearchMapFilterTableViewCell.swift
//  TGK
//
//  Created by Jay Park on 2/22/20.
//  Copyright © 2020 TheGivingKitchen. All rights reserved.
//

import Foundation
import UIKit

protocol StabilityNetSearchMapFilterTableViewCellDelegate:class {
    func stabilityNetSearchMapFilterTableViewCellDidTapFilter()
}

class StabilityNetSearchMapFilterTableViewCell:UITableViewCell {
    
    @IBOutlet weak var filterButton: UIButton!
    
    weak var delegate:StabilityNetSearchMapFilterTableViewCellDelegate?
    
    override func awakeFromNib() {
        self.styleView()
    }
    
    @IBAction func filterButtonTapped(_ sender: Any) {
        self.delegate?.stabilityNetSearchMapFilterTableViewCellDidTapFilter()
    }
    
    private func styleView() {
        self.filterButton.titleLabel?.font = UIFont.tgkNavigation
        self.filterButton.tintColor = UIColor.tgkYellow
    }
    
}
