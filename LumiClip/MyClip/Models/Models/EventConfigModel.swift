//
//  EventConfigModel.swift
//  MyClip
//
//  Created by Manh Hoang Xuan on 5/28/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import Foundation
class EventConfigModel: NSObject {
    var startEventDate: String
    var eventMonthRanges: [MonthRangeModel]
    var termsCondition: String
    override init(){
        startEventDate = ""
        termsCondition = ""
        eventMonthRanges = []
    }
    init(_ dto: EventConfigDTO) {
        startEventDate = dto.startEventDate
        termsCondition = dto.termsCondition
        eventMonthRanges = []
        for subDTO in dto.eventMonthRanges {
            eventMonthRanges.append(MonthRangeModel(subDTO))
        }
    }
}
