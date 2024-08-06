//
//  MemberDTO.swift
//  MyClip
//
//  Created by Hoang on 3/17/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON

class MemberDTO: NSObject {
    var avatarImage: String
    var accessToken: String
    var expiredTime: Int
    var isUpdateApp: Bool
    var msisdn: String
    var isForceUpdateApp: Bool
    var refreshToken: String
    var fullName: String
    var needShowMapAccount: Bool
    var isShowSuggestTopic: Bool
    var needChangePassword: Bool
    var desc: String
    var coverImage: String
    var userId: String
    var notify_comment: String
    var firstTimeLoginAPP: Int
    var isShowPromotionAPP: Int
    var status: Int?
    var isUpLoad : Int
    var reason : String
   var themeUser : Int
    init(_ json: JSON) {
        avatarImage        = json["avatarImage"].stringValue
        accessToken        = json["accessToken"].stringValue
        expiredTime        = json["expiredTime"].intValue
        isUpdateApp        = json["isUpdateAPP"].boolValue
        msisdn             = json["msisdn"].stringValue
        isForceUpdateApp   = json["isForceUpdateApp"].boolValue
        refreshToken       = json["refressToken"].stringValue
        fullName           = json["fullname"].stringValue
        needShowMapAccount = json["needShowMapAccount"].boolValue
        isShowSuggestTopic = json["isShowSuggestTopic"].boolValue
        needChangePassword = json["needChangePassword"].boolValue
        desc = json["description"].stringValue
        coverImage         = json["coverImage"].stringValue
        userId             = json["userId"].stringValue
        notify_comment     = json["notify_comment"].stringValue
        firstTimeLoginAPP  = json["firstTimeLoginAPP"].intValue
        isShowPromotionAPP = json["isShowPromotionAPP"].intValue
        status = json["status"].intValue
        isUpLoad = json["isupload"].intValue
        reason = json["reason"].stringValue
      themeUser = json["theme"].intValue
    }
}
