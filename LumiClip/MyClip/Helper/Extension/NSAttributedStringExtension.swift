//
//  NSAttributedStringExtension.swift
//  MyClip
//
//  Created by Manh Hoang on 2/27/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import UIKit

extension NSAttributedString {
    internal convenience init?(html: String) {
        guard let data = html.data(using: String.Encoding.utf16, allowLossyConversion: false) else {
            return nil
        }
        guard let attributedString = try? NSMutableAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue] as [NSAttributedString.DocumentReadingOptionKey : Any], documentAttributes: nil) else {
            return nil
        }
        attributedString.addAttributes([NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 14)!], range: NSMakeRange(0, attributedString.length))
        self.init(attributedString: attributedString)
    }
}
