//
//  EarningInfoDTO.swift
//  MyClip
//
//  Created by Manh Hoang Xuan on 7/10/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON

class EarningInfoDTO : NSObject {
    var hintMessage: String
    var currentRevenue: String
    var currentRevenueStr: String
    var histories: [EarningItemDTO]
    init(_ json: JSON) {
        hintMessage           = json["hintMessage"].stringValue
        currentRevenue        = json["currentRevenue"].stringValue
        currentRevenueStr     = json["currentRevenueStr"].stringValue
        histories = []
        for (_, subJson) in json["histories"] {
            let dto = EarningItemDTO(subJson)
            histories.append(dto)
        }
    }
}
