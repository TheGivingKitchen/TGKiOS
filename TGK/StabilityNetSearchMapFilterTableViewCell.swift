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
    
    private var defaultFilterButtonText = "Tap To Filter By Category"
    
    override func awakeFromNib() {
        self.styleView()
        self.filterButton.setTitle(self.defaultFilterButtonText, for: .normal)
    }
    
    private func styleView() {
        self.filterButton.titleLabel?.font = UIFont.tgkNavigation
        self.filterButton.tintColor = UIColor.tgkOrange
        self.filterButton.setTitleColor(UIColor.tgkOrange, for: .normal)
        self.filterButton.imageView?.contentMode = .scaleAspectFit
    }
    
    func configureWithFilters(selectedCategories:Set<String>) {
        if selectedCategories.count == 0 {
            self.filterButton.setTitle(self.defaultFilterButtonText, for: .normal)
        }
        else if selectedCategories.count == 1 {
            self.filterButton.setTitle("Filtering by 1 category", for: .normal)
        }
        else {
            self.filterButton.setTitle("Filtering by \(selectedCategories.count) categories", for: .normal)
        }
        
    }
    
    @IBAction func filterButtonTapped(_ sender: Any) {
        self.delegate?.stabilityNetSearchMapFilterTableViewCellDidTapFilter()
    }
    
    
    
}
