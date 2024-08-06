//
//  AppColor.swift
//  MyClip
//
//  Created by Admin on 3/10/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation
import UIKit

class AppColor: NSObject {

    class func navigationColor() -> UIColor {
        return UIColor.colorFromHexa("003365")
    }
    
    class func mainColor() -> UIColor {
        return UIColor.colorFromHexa("F99F19")
    }
    
    class func babyBlueColor() -> UIColor {
        return UIColor.colorFromHexa("a0d0ff")
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

    class func searchBarBackgroundColor() -> UIColor {
        return UIColor.colorFromHexa("282828")
    }

    class func coolGreenColor() -> UIColor {
        return UIColor.colorFromHexa("3ac663")
    }

    class func imBlackColor() -> UIColor {
        return UIColor.colorFromHexa("333333")
    }

    class func imWarmGrey() -> UIColor {
        return UIColor.colorFromHexa("888888")
    }

    class func grayButtonColor() -> UIColor {
        return UIColor.colorFromHexa("dcdcdc")
    }

    class func blackTitleColor() -> UIColor {
        return UIColor.colorFromHexa("222222")
    }

    class func darkGray() -> UIColor {
        return UIColor.colorFromHexa("d9d9d9")
    }

    class func whiteThree() -> UIColor {
        return UIColor.colorFromHexa("E1E1E1")
    }

    class func bloodOrange() -> UIColor {
        return UIColor.colorFromHexa("ff4200")
    }

    class func trueGreen() -> UIColor {
        return UIColor.colorFromHexa("09ba00")
    }

    class func darkSkyBlue() -> UIColor {
        return UIColor.colorFromHexa("4fcee9")
    }

    class func greyishBrown() -> UIColor {
        return UIColor.colorFromHexa("555555")
    }
    
    class func deepSkyBlue90() -> UIColor {
        return UIColor(red: 0, green: 157.0/255.0, blue: 253.0/255.0, alpha: 1)
    }
    
    class func warmGreyTwo() -> UIColor {
        return UIColor.colorFromHexa("727272")
    }

    class func randomColor() -> UIColor {
        let number1 = Float(arc4random_uniform(UInt32(216)+10))
        let number2 = Float(arc4random_uniform(UInt32(216)+10))
        let number3 = Float(arc4random_uniform(UInt32(216)+10))
        return UIColor.init(_colorLiteralRed: number1/255.0,
                            green: number2/255.0,
                            blue: number3/255.0,
                            alpha: 1)
    }
}
