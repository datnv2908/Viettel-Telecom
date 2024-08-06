//
//  AppFont.swift
//  5dmax
//
//  Created by Admin on 3/10/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation
import UIKit

enum AppFontStyle {
    case regular
    case light
    case italic
    case bold
    case semibold
}

class AppFont: NSObject {
    class func fontWithStyle(style: AppFontStyle, size: CGFloat) -> UIFont {
        let mappedFontStyle: SFUIDisplayFontStyle

        switch style {
        case .regular:
            mappedFontStyle = .regular
        case .light:
            mappedFontStyle = .light
        case .italic:
            mappedFontStyle = .thin
        case .bold:
            mappedFontStyle = .bold
        case .semibold:
            mappedFontStyle = .semibold
        }
        return SFUIDisplayFont.fontWithType(mappedFontStyle, size: size)
    }
    class func museoSanFont(style: AppFontStyle, size: CGFloat) -> UIFont {
        let mappedFontStyle: MuseoSanFontStyle
        
        switch style {
        case .regular:
            mappedFontStyle = .regular
        case .light:
            mappedFontStyle = .light
        case .bold:
            mappedFontStyle = .bold
        case .semibold:
            mappedFontStyle = .semibold
        case .italic:
            mappedFontStyle = .medium
        }
        return MuseoSanFont.museoSanWithType(type: mappedFontStyle, size: size)
    }
}
