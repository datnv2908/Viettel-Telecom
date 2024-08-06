//
//  UserAwardDTO.swift
//  MyClip
//
//  Created by Manh Hoang Xuan on 5/29/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON

class UserAwardDTO : NSObject {
    var userId: Int
    var msisdn: String
    var awardType: String
    var awardName: String
    var point: Int
    init(_ json: JSON) {
        userId      = json["user_id"].intValue
        msisdn            = json["msisdn"].stringValue
        awardType        = json["award_type"].stringValue
        awardName = json["award_name"].stringValue
        point              = json["point"].intValue
    }
}

