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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bottomDividerView: UIView!
    
    var calendarEventModel:RSSCalendarEventModel! {
        didSet {
            self.configureView()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.descriptionLabel.font = UIFont.tgkBody
        self.descriptionLabel.textColor = UIColor.tgkDarkGray
        
        self.titleLabel.font = UIFont.tgkSubtitle
        self.titleLabel.textColor = UIColor.tgkOrange
        self.bottomDividerView.backgroundColor = UIColor.tgkBackgroundGray
        
        //gradient
//        let gradient = CAGradientLayer()
//        gradient.frame = self.heroImageVIew.bounds
//        gradient.colors = [UIColor.clear.cgColor, UIColor.tgkDarkDarkGray.cgColor]
//        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
//        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
//        self.heroImageVIew.layer.insertSublayer(gradient, at: 0)
    }
    
    private func configureView() {
        if let imageUrlString = self.calendarEventModel.imageUrlString,
            let imageUrl = URL(string: imageUrlString) {
            self.heroImageVIew.af_setImage(withURL: imageUrl)
        }
        
        self.titleLabel.text = calendarEventModel.title
        self.descriptionLabel.text = calendarEventModel.description
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }


}
