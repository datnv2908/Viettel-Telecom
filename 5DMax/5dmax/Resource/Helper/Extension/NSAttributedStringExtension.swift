//
//  NSAttributedStringExtension.swift
//  MyClip
//
//  Created by Manh Hoang on 2/27/18.
//  Copyright :copyright: 2018 Huy Nguyen. All rights reserved.
//

import UIKit

extension NSAttributedString {
    internal convenience init?(html: String) {
        guard let data = html.data(using: String.Encoding.utf16, allowLossyConversion: false) else {
            return nil
        }
        guard let attributedString = try? NSMutableAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) else {
            return nil
        }
        self.init(attributedString: attributedString)
    }
}
