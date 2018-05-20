//
//  UIFont+TGK.swift
//  TGK
//
//  Created by Jay Park on 5/20/18.
//  Copyright © 2018 TheGivingKitchen. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    static func robotoMono(size:CGFloat) -> UIFont {
        return UIFont(name: "RobotoMono-Regular", size: size) ?? UIFont.systemFont(ofSize:size)
    }
    
    static func robotoMonoBold(size:CGFloat) -> UIFont {
        return UIFont(name: "RobotoMono-Bold", size: size) ?? UIFont.systemFont(ofSize:size)
    }
    
    static func robotoMonoBoldItalic(size:CGFloat) -> UIFont {
        return UIFont(name: "RobotoMono-BoldItalic", size: size) ?? UIFont.systemFont(ofSize:size)
    }
    
    static func robotoMonoItalic(size:CGFloat) -> UIFont {
        return UIFont(name: "RobotoMono-Italic", size: size) ?? UIFont.systemFont(ofSize:size)
    }
    
    static func robotoMonoLight(size:CGFloat) -> UIFont {
        return UIFont(name: "RobotoMono-Light", size: size) ?? UIFont.systemFont(ofSize:size)
    }
    
    static func robotoMonoLightItalic(size:CGFloat) -> UIFont {
        return UIFont(name: "RobotoMono-LightItalic", size: size) ?? UIFont.systemFont(ofSize:size)
    }
    
    static func robotoMonoMedium(size:CGFloat) -> UIFont {
        return UIFont(name: "RobotoMono-Medium", size: size) ?? UIFont.systemFont(ofSize:size)
    }
    
    static func robotoMonoMediumItalic(size:CGFloat) -> UIFont {
        return UIFont(name: "RobotoMono-MediumItalic", size: size) ?? UIFont.systemFont(ofSize:size)
    }
    
    static func robotoMonoThin(size:CGFloat) -> UIFont {
        return UIFont(name: "RobotoMono-Thin", size: size) ?? UIFont.systemFont(ofSize:size)
    }
    
    static func robotoMonoThinItalic(size:CGFloat) -> UIFont {
        return UIFont(name: "RobotoMono-ThinItalic", size: size) ?? UIFont.systemFont(ofSize:size)
    }
    
    static func beckerEgyptian(size:CGFloat) -> UIFont {
        return UIFont(name: "BeckerGothics-Egyptian", size: size) ?? UIFont.systemFont(ofSize:size)
    }
    
    static func kulturistaBold(size:CGFloat) -> UIFont {
        return UIFont(name: "Kulturista-Bold", size: size) ?? UIFont.systemFont(ofSize:size)
    }
    
    static func kulturistaMedium(size:CGFloat) -> UIFont {
        return UIFont(name: "Kulturista", size: size) ?? UIFont.systemFont(ofSize:size)
    }
}

//MARK: header and body wrappers for styling
extension UIFont {
    static var tgkH1:UIFont {
        return UIFont.beckerEgyptian(size: 44)
    }
    
    static var tgkH2:UIFont {
        return UIFont.kulturistaBold(size: 30)
    }
    
    static var tgkH3:UIFont {
        return UIFont.beckerEgyptian(size: 30)
    }
    
    static var tgkH4:UIFont {
        return UIFont.kulturistaMedium(size: 17)
    }
    
    static var tgkH5:UIFont {
        return UIFont.robotoMono(size: 17)
    }
    
    static var tgkBody:UIFont {
        return UIFont.robotoMono(size: 17)
    }
}
