//
//  NotificationDTO.swift
//  5dmax
//
//  Created by Os on 4/10/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON
class NotificationDTO: NSObject {
    var userId:String
    var name: String
    var message: String
    var id:String
    var uniqId:String
    var groupId: String
    var type: String
    var image: String
    var imageH: String
    var senttime: String
    var action: String
    init(_ json: JSON) {
        userId      = json["user_id"].stringValue
        name        = json["name"].stringValue
        senttime    = json["sent_time"].stringValue
        message     = json["message"].stringValue
        id          = json["id"].stringValue
        uniqId      = json["uniq_id"].stringValue
        groupId     = json["group_id"].stringValue
        type        = json["type"].stringValue
        image       = json["image"].stringValue
        imageH      = json["imageH"].stringValue
        action      = json["action"].stringValue
    }
}
