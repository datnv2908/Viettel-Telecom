//
//  EarningInfoModel.swift
//  MyClip
//
//  Created by Manh Hoang Xuan on 7/11/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import Foundation

class EarningInfoModel: NSObject {
    var hintMessage: String
    var currentRevenue: String
    var currentRevenueStr: String
    var histories: [EarningItemModel]
    override init(){
        hintMessage = ""
        currentRevenue = ""
        currentRevenueStr = ""
        histories = []
    }
    init(_ dto: EarningInfoDTO) {
        self.hintMessage = dto.hintMessage
        self.currentRevenue = dto.currentRevenue
        self.currentRevenueStr = dto.currentRevenueStr
    
        histories = []
        for subDTO in dto.histories {
            histories.append(EarningItemModel(subDTO))
        }
    }
}
