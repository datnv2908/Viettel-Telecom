//
//  MemberDTO.swift
//  5dmax
//
//  Created by Hoang on 3/17/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON

class MemberDTO: NSObject {

    var accessToken: String
    var refressToken: String
    var fullname: String
    var msisdn: String
    var userId: Int
    var expiredTime: Int
    var isShowSuggestTopic: Int
    var needShowMapAccount: Int
    var isForceUpdateAPP: Int
    var isUpdateAPP: Int
    var needChangePassword: Bool
    var firstTimeLoginAPP: Int
    var isShowPromotionAPP: Int

    init(_ json: JSON) {
        accessToken         = json["accessToken"].stringValue
        refressToken        = json["refressToken"].stringValue
        fullname            = json["fullname"].stringValue
        msisdn              = json["msisdn"].stringValue
        userId              = json["userId"].intValue
        expiredTime         = json["expiredTime"].intValue
        isShowSuggestTopic  = json["isShowSuggestTopic"].intValue
        needShowMapAccount  = json["needShowMapAccount"].intValue
        isForceUpdateAPP    = json["isForceUpdateAPP"].intValue
        isUpdateAPP         = json["isUpdateAPP"].intValue
        needChangePassword  = json["needChangePassword"].boolValue
        firstTimeLoginAPP  = json["firstTimeLoginAPP"].intValue
        isShowPromotionAPP = json["isShowPromotionAPP"].intValue
    }
}
