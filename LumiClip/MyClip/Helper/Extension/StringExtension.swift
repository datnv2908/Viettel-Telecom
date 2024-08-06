//
//  StringExtension.swift
//  MyClip
//
//  Created by Admin on 3/10/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation
import UIKit

extension String {

    func getDateWithFormat(_ format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        if let date = formatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }

    func isPhoneNumberInvalid() -> Bool {
        if self.isEmpty {
            return false
        }
        let charcterSet  = NSCharacterSet(charactersIn: "+0123456789").inverted
        let phoneNumber = self
        let inputString = phoneNumber.components(separatedBy: charcterSet)
        let filtered = inputString.joined(separator: "")
        return  phoneNumber == filtered
    }

    func phoneNumber() -> String! {

        if let firstNumber = self.first {

            if firstNumber == "0" {
                var text = self
                text.remove(at: text.startIndex)
                return text
            }
        }
        return self
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

    var html2AttributedString: NSAttributedString? {
        guard
            let data = data(using: String.Encoding.utf8)
            else { return nil }
        do {
            return try NSAttributedString(data: data,
                                          options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue] as [NSAttributedString.DocumentReadingOptionKey : Any],
                                          documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
    
    func getResolutionName() -> String {
        let lineObj = self as NSString
        let regex = try! NSRegularExpression(pattern: "RESOLUTION=(\\d+)x(\\d+)",
                                             options: NSRegularExpression.Options.caseInsensitive)
        let matches = regex.matches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0),
                                    range: NSRange(location: 0, length: lineObj.length) )
        
        let range1 = matches[0].range(at: 1)
        let range2 = matches[0].range(at: 2)
        
        var resolution = "Unknown"
        if range1.location != NSNotFound || range2.location != NSNotFound {
            resolution = String(format: "%@p", lineObj.substring(with: range2))
        }
        return resolution
    }
    
    mutating func translateTime() -> String {
        let originWords = ["sencond", "minute", "hour", "day", "week", "month", "year",
                         "senconds", "minutes", "hours", "days", "weeks", "months", "years", "ago"]
        let replaceWords = [String.giay.lowercased(), String.phut.lowercased(), String.gio.lowercased(), String.ngay.lowercased(), String.tuan.lowercased(), String.thang.lowercased(), String.nam.lowercased(),
                            String.giay.lowercased(), String.phut.lowercased(), String.gio.lowercased(), String.ngay.lowercased(), String.tuan.lowercased(), String.thang.lowercased(), String.nam.lowercased(), String.truoc.lowercased()]
        for pair in zip(originWords, replaceWords) {
            self = correct(string: self, origin: pair.0, replace: pair.1)
        }
        return self
    }
    
    private func correct(string: String, origin: String, replace: String) -> String {
        let s = NSMutableString(string: string)
        guard let r = try? NSRegularExpression(pattern: "\\b\(origin)\\b", options: .caseInsensitive) else {return ""}
        r.replaceMatches(in: s, range: NSMakeRange(0,s.length), withTemplate: replace)
        return s as String
    }
    var condensedWhitespace: String {
        let components = self.components(separatedBy: NSCharacterSet.whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }
    func uperCaseFirst() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
