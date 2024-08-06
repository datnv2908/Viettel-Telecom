//
//  MonthRangeModel.swift
//  MyClip
//
//  Created by Manh Hoang Xuan on 5/28/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import Foundation
class MonthRangeModel: NSObject {
    var key: String
    var value: String
    init(_ dto: MonthRangeDTO) {
        key = dto.key
        value = dto.value
    }
}
