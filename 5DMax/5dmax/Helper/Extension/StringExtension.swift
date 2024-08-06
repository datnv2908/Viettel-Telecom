//
//  StringExtension.swift
//  5dmax
//
//  Created by Admin on 3/10/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation
import UIKit

extension String {

    func getDateWithFormat(_ format: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US_POSIX")
        if let date = formatter.date(from: self) {
            return date
        } else {
            return Date(timeIntervalSince1970: 0)
        }
    }
    
    func getDateTimeCurrent() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        let dateString = formatter.string(from: date)
        return dateString
    }
    
    func isPhoneNumberInvalid() -> Bool {
        if self.characters.isEmpty {
            return false
        }
        let charcterSet  = NSCharacterSet(charactersIn: "+0123456789").inverted
        let phoneNumber = self
        let inputString = phoneNumber.components(separatedBy: charcterSet)
        let filtered = inputString.joined(separator: "")
        return  phoneNumber == filtered
    }

    func phoneNumber() -> String! {
        if let firstNumber = self.characters.first {

            if firstNumber == "0" {
                var text = self
                text.remove(at: text.startIndex)
                return text
            }
        }
        return self
    }
    
    func smsPhoneNumber() -> String! {
        
        let text = self
        let phoneNumber = "\(text)"
        return phoneNumber
    }
    
    func isNumberInvalid() -> Bool {
        if Int(self) != nil {
            return true
        }
        return false
    }

    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }

    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
    
    static func displayMoneyFormatWithInValue(_ number: Int)-> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .decimal
        currencyFormatter.groupingSeparator = "."
        currencyFormatter.groupingSize = 3
        currencyFormatter.decimalSeparator = ","
        
        if let priceString = currencyFormatter.string(from: NSNumber(integerLiteral: number)) {
            return priceString
        }
        return ""
    }
    
    func capitalizingFirstLetter() -> String {
        if self.count == 0 {
            return ""
        }
        let str = self.lowercased()
        return str.prefix(1).uppercased() + str.dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func convertHtml() -> NSAttributedString{
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do{
            let color = UIColor(red: 153.0 / 255.0, green: 153.0 / 255.0, blue: 153.0 / 255.0, alpha: 1.0)
//            let attrs1: [String: AnyObject] = [NSFontAttributeName : UIFont.systemFont(ofSize: 15.0), NSForegroundColorAttributeName : color]
//            var attributes: NSDictionary? = [NSForegroundColorAttributeName : UIColor.white]
            let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue] as [NSAttributedString.DocumentReadingOptionKey : Any]
            var att = try NSAttributedString(data: data, options: options, documentAttributes: nil)
            
            return att
        } catch {
            return NSAttributedString()
        }
    }
}
