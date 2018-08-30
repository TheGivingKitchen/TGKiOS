//
//  String+Base64.swift
//  WufooPOC
//
//  Created by Jay Park on 4/7/18.
//  Copyright © 2018 ThoughtSeize. All rights reserved.
//

import Foundation
import UIKit

extension String {
    var base64String:String {
        guard let stringData = self.data(using: .utf8) else {
            return ""
        }
        return stringData.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
    }
    
    func formatStringToPhoneNumber() -> String {
        var numericString = self.components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
        if numericString.count >= 4 {
            numericString.insert(")", at: numericString.index(numericString.startIndex, offsetBy: 3))
            numericString.insert("(", at: numericString.startIndex)
            numericString.insert(" ", at: numericString.index(numericString.startIndex, offsetBy: 5))
        }
        if numericString.count >= 10 {
            numericString.insert("-", at: numericString.index(numericString.startIndex, offsetBy: 9))
        }
        if numericString.count > 14 {
            numericString = String(numericString.dropLast(numericString.count - 14))
        }
        return numericString
    }
    
    func formatStringToNumericString() -> String {
        let numericString = self.components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
        return numericString
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font : font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font : font], context: nil)
        
        return ceil(boundingBox.width)
    }
}

extension Optional where Wrapped == String {
    public var isNilOrEmpty: Bool {
        if let text = self, !text.isEmpty { return false }
        return true
    }
}
