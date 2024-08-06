//
//  EventConfigDTO.swift
//  MyClip
//
//  Created by Manh Hoang Xuan on 5/28/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import Foundation
import SwiftyJSON

class EventConfigDTO : NSObject {
    var startEventDate: String
    var eventMonthRanges: [MonthRangeDTO]
    var termsCondition: String
    init(_ json: JSON) {
        startEventDate      = json["start_event_date"].stringValue
        termsCondition      = json["terms-condition"].stringValue
        eventMonthRanges = []
        for (_, subJson) in json["event_month_range"] {
            let dto = MonthRangeDTO(subJson)
            eventMonthRanges.append(dto)
        }
    }
}
