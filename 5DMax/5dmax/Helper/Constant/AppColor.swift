//
//  AppColor.swift
//  5dmax
//
//  Created by Admin on 3/10/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation
import UIKit

class AppColor: NSObject {

    class func navigationColor() -> UIColor {
        return UIColor.colorFromHexa("121212")
    }

    class func imageBackgroundColor() -> UIColor {
        return UIColor.colorFromHexa("282828")
    }

    class func blackBackgroundColor() -> UIColor {
        return UIColor.colorFromHexa("181818")
    }

    class func grayBackgroundColor() -> UIColor {
        return UIColor.colorFromHexa("f0f0f0")
    }
    
    class func blackLogingroundColor() -> UIColor {
        return UIColor(red: 24/255, green: 24/255, blue: 24/255, alpha: 1)
    }
    
    class func searchBarBackgroundColor() -> UIColor {
        return UIColor.colorFromHexa("282828")
    }

    class func whiteFiveColor() -> UIColor {
        return UIColor.init(red: 230.0/255.0, green: 230.0/255.0, blue: 230.8/255.0, alpha: 1.0)
    }

    class  func warmGreyThreeColor() -> UIColor {
        return UIColor.init(red: 153.0/255.0, green: 153.0/255.0, blue: 153.8/255.0, alpha: 1.0)
    }

    class func warmGrey() -> UIColor {
        return UIColor.colorFromHexa("999999")
    }

    class func black() -> UIColor {
        return UIColor.colorFromHexa("333333")
    }

    class func blackTwo() -> UIColor {
        return UIColor.colorFromHexa("181818")
    }

    class func blue() -> UIColor {
        return UIColor.init(red: 33.0/255.0, green: 147.0/255.0, blue: 232.0/255.0, alpha: 1.0)
    }

    class func pinkishGrey() -> UIColor {
        return UIColor.colorFromHexa("c2c2c2")
    }

    class func whiteTwo() -> UIColor {
        return UIColor.colorFromHexa("f0f0f0")
    }

    class func brownishGrey() -> UIColor {
        return UIColor.colorFromHexa("5f5f5f")
    }

    class func untCharcoalGrey() -> UIColor {
        return UIColor.colorFromHexa("383839")
    }

    class func untAvocadoGreen() -> UIColor {
        return UIColor.colorFromHexa("65b01b")
    }

    class func untAvocadoGreenLight() -> UIColor {
        return UIColor(red: 170.0 / 255.0, green: 208.0 / 255.0, blue: 134.0 / 255.0, alpha: 1.0)
    }

    class func darkSkyBlue() -> UIColor {
        return UIColor.colorFromHexa("2b93e8")
    }

    class func darkGrey() -> UIColor {
        return UIColor.colorFromHexa("0f0f10")
    }
    
    class func green() -> UIColor {
        return UIColor(red: 41/255, green: 180/255, blue: 85/255, alpha: 1)
    }
    
    class func graySearchBar() -> UIColor {
        return UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
    }
    
    class func e5e5e6Color()-> UIColor {
        return UIColor.colorFromHexa("e5e5e6")
    }
    
    class func r226g11b19Color()-> UIColor {
        return UIColor(red: 226/255, green: 11/255, blue: 19/255, alpha: 1)
    }
    class func hexfded00Color()-> UIColor {
        return UIColor.colorFromHexa("fded00")
       }
    class func hex000001Color()-> UIColor {
        return UIColor.colorFromHexa("000001")
    }
}
