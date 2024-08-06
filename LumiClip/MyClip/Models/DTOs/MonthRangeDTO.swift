//
//  MonthRangeDTO.swift
//  MyClip
//
//  Created by Manh Hoang Xuan on 5/28/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import Foundation
import SwiftyJSON

class MonthRangeDTO : NSObject {
    var key: String
    var value: String
    init(_ json: JSON) {
        key      = json["key"].stringValue
        value    = json["value"].stringValue
    }
}
