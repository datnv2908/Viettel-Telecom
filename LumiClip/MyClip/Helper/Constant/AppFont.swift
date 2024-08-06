//
//  AppFont.swift
//  MyClip
//
//  Created by Admin on 3/10/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation
import UIKit

enum AppFontStyle {
    case regular
    case medium
    case semibold
    case bold
}

enum SystemFont: String {
    case regular
    case medium
    case semibold
    case bold
}

class AppFont: NSObject {
    class func font(size: CGFloat) -> UIFont {
        return SFUIDisplayFont.fontWithType(.regular, size: size)
    }

    class func font(style: AppFontStyle, size: CGFloat) -> UIFont {
        switch style {
        case .bold:
            return SFUIDisplayFont.fontWithType(.bold, size: size)
        case .regular:
            return SFUIDisplayFont.fontWithType(.regular, size: size)
        case .medium:
            return SFUIDisplayFont.fontWithType(.medium, size: size)
        case .semibold:
            return SFUIDisplayFont.fontWithType(.semibold, size: size)
        }
    }
}
