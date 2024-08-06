//
//  UserAwardModel.swift
//  MyClip
//
//  Created by Manh Hoang Xuan on 5/29/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import UIKit

class UserAwardModel: NSObject {
    var userId: Int
    var msisdn: String
    var awardType: String
    var awardName: String
    var point: Int
    init(_ dto: UserAwardDTO) {
        userId      = dto.userId
        msisdn      = dto.msisdn
        awardType   = dto.awardType
        awardName   = dto.awardName
        point       = dto.point
    }
    
    init(userId:Int, msisdn: String, awardType: String, awardName: String, point:Int){
        self.userId = userId
        self.msisdn = msisdn
        self.awardType = awardType
        self.awardName = awardName
        self.point = point
    }
}
