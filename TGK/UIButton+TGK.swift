//
//  UIButton+TGK.swift
//  TGK
//
//  Created by Jay Park on 9/1/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    func setTemplateImage(named imageName:String, for controlState:UIControlState, tint:UIColor) {
        let templateImage = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        self.setImage(templateImage, for: controlState)
        self.tintColor = tint
    }
}
