//
//  EarningItemDTO.swift
//  MyClip
//
//  Created by Manh Hoang Xuan on 7/10/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON

class EarningItemDTO : NSObject {
    var month: String
    var revenue: String
    var revenueStr: String
    var status: String
    var displayMore: String
    
    init(_ json: JSON) {
        month        = json["month"].stringValue
        revenue      = json["revenue"].stringValue
        revenueStr   = json["revenue_str"].stringValue
        status       = json["status"].stringValue
        displayMore  = json["display_more"].stringValue
    }
}
