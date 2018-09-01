//
//  SafetyNetHomeTooltipCell.swift
//  TGK
//
//  Created by Jay Park on 8/31/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import UIKit

protocol SafetyNetHomeTooltipCellDelegate:class {
    func safetyNetHomeTooltipCellDidPressClose(cell:SafetyNetHomeTooltipCell)
}

class SafetyNetHomeTooltipCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var bottomSeparatorView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    
    weak var delegate:SafetyNetHomeTooltipCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        self.styleView()
    }
    
    
    private func styleView() {
        self.descriptionLabel.font = UIFont.tgkBody
        self.descriptionLabel.textColor = UIColor.tgkBlue
        
        self.bottomSeparatorView.backgroundColor = UIColor.tgkBackgroundGray
        
        self.closeButton.setTemplateImage(named: "iconCloseX", for: .normal, tint: UIColor.tgkBlue)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func closePressed(_ sender: Any) {
        self.delegate?.safetyNetHomeTooltipCellDidPressClose(cell: self)
    }
}
