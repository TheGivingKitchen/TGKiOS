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

//MARK: Dynamic typed header and body wrappers for styling
extension UIFont {
    static var tgkTitle:UIFont {
        return UIFontMetrics.default.scaledFont(for:UIFont.beckerEgyptian(size: 36))
    }
    
    static var tgkSubtitle:UIFont {
        return UIFontMetrics.default.scaledFont(for:UIFont.kulturistaBold(size: 24))
    }
    
    static var tgkContentBlockTitle:UIFont {
        return UIFontMetrics.default.scaledFont(for:UIFont.beckerEgyptian(size: 30))
    }
    
    static var tgkNavigation:UIFont {
        return UIFontMetrics.default.scaledFont(for:UIFont.kulturistaMedium(size: 17))
    }
    
    static var tgkBody:UIFont {
        return UIFontMetrics.default.scaledFont(for:UIFont.robotoMono(size: 15))
    }
    
    static var tgkMetadata:UIFont {
        return UIFontMetrics.default.scaledFont(for:UIFont.robotoMono(size: 15))
    }
}
