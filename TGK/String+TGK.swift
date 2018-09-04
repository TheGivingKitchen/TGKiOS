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
    
    func formatStringToUSD() -> String {
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        var amountWithPrefix = self
        
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }
        
        return formatter.string(from: number)!
    }
    
}

extension Optional where Wrapped == String {
    public var isNilOrEmpty: Bool {
        if let text = self, !text.isEmpty { return false }
        return true
    }
}
