//
//  SFUIDisplayFont.swift
//  5dmax
//
//  Created by Admin on 3/10/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

enum SFUIDisplayFontStyle: String {
    case bold
    case heavy
    case light
    case medium
    case regular
    case semibold
    case thin
    case ultralight
    case black

    func fontName() -> String {
        switch self {
        case .bold:
            return "SFUIDisplay-Bold"
        case .heavy:
            return "SF-UI-Display-Heavy"
        case .light:
            return "SF-UI-Display-Light"
        case .medium:
            return "SF-UI-Display-Medium"
        case .regular:
            return "SF-UI-Display-Regular"
        case .semibold:
            return "SF-UI-Display-Semibold"
        case .thin:
            return "SF-UI-Display-Thin"
        case .ultralight:
            return "SF-UI-Display-Ultralight"
        case .black:
            return "SF-UI-Display-Black"
        }
    }
}

class SFUIDisplayFont: UIFont {

    class func fontWithType(_ type: SFUIDisplayFontStyle, size: CGFloat) -> UIFont {
        if let font = UIFont(name: type.fontName(), size: size) {
            return font
        } else {
            // default return system font
            return UIFont.systemFont(ofSize: size)
        }
    }

}
