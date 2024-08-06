//
//  KPIToken.swift
//  MyClip
//
//  Created by hnc on 11/1/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON

class KPIToken: NSObject {
    var token: String
    var frequency: Int
    init(_ json: JSON) {
        token = json["token"].stringValue
        if json["frequency"].exists() {
            frequency = json["frequency"].intValue
        } else {
            frequency = 10
        }
    }
}
