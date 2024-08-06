//
//  MuseoSanFont.swift
//  5dmax
//
//  Created by Toan on 5/5/21.
//  Copyright © 2021 Huy Nguyen. All rights reserved.
//

import UIKit

enum MuseoSanFontStyle: String {
    case light
    case regular
    case medium
    case semibold
    case bold
   func fontName() -> String {
    switch self {
    case .light:
        return "MuseoSans-100"
    case .regular :
        return "MuseoSans-300"
    case .medium :
        return "MuseoSans_500"
    case .semibold :
        return "MuseoSans_700"
    case .bold :
       return  "MuseoSans-900"
    }
    }
}
class MuseoSanFont : UIFont{
    class func  museoSanWithType (type : MuseoSanFontStyle , size : CGFloat) -> UIFont{
        if let  font = UIFont(name: type.fontName(), size: CGFloat(size)) {
            return font
        }else{
            return UIFont.systemFont(ofSize: size)
        }
        
        
    }
}
