//
//  CalendarEventOverviewTableViewCell.swift
//  TGK
//
//  Created by Jay Park on 6/7/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import UIKit
import AlamofireImage

class CalendarEventOverviewTableViewCell: UITableViewCell {

    @IBOutlet weak var heroImageVIew: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var calendarEventModel:RSSCalendarEventModel! {
        didSet {
            self.configureView()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.descriptionLabel.font = UIFont.tgkBody
        self.descriptionLabel.textColor = UIColor.tgkDarkGray
    }
    
    private func configureView() {
        if let imageUrlString = self.calendarEventModel.imageUrlString,
            let imageUrl = URL(string: imageUrlString) {
            self.heroImageVIew.af_setImage(withURL: imageUrl)
        }
        
        self.descriptionLabel.text = calendarEventModel.description
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }


}
