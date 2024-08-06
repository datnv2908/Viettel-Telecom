//
//  EarningItemModel.swift
//  MyClip
//
//  Created by Manh Hoang Xuan on 7/11/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import Foundation

class EarningItemModel: NSObject {
    var month: String
    var revenue: String
    var revenueStr: String
    var status: String
    var displayMore: String
    init(_ dto: EarningItemDTO) {
        month = dto.month
        revenue = dto.month
        revenueStr = dto.revenueStr
        status = dto.status
        displayMore = dto.displayMore
    }
    
    init(month:String, revenue: String, revenueStr: String, status: String, displayMore:String){
        self.month = month
        self.revenue = revenue
        self.revenueStr = revenueStr
        self.status = status
        self.displayMore = displayMore
    }
}
