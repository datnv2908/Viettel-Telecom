//
//  ChannelDTO.swift
//  MyClip
//
//  Created by Huy Nguyen on 9/22/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON

class ChannelDTO: NSObject {
    var id: String
    var name: String
    var avatarImage: String
    var coverImage: String
    var num_follow: Int
    var num_video: Int
    var desc: String
    var notificationType: Int
    var isFollow: Bool
   var channelId : String
   var isOffical : Bool
   var freeVideo : Bool
    init(_ json: JSON) {
        id = json["id"].exists() ? json["id"].stringValue : json["channel_id"].stringValue
        name = json["name"].exists() ? json["name"].stringValue : json["channel_name"].stringValue
        avatarImage = json["avatarImage"].stringValue
        coverImage = json["coverImage"].stringValue
        num_follow = json["num_follow"].exists() ? json["num_follow"].intValue : json["followCount"].intValue
        num_video = json["num_video"].intValue
        desc = json["description"].stringValue
        isFollow = json["isFollow"].exists() ? json["isFollow"].boolValue : json["is_follow"].boolValue
        notificationType = json["notification_type"].intValue
      channelId = json["channel_id"].stringValue
      isOffical = json["official"].boolValue
      if json["price_play"].stringValue ==  "0" {
               self.freeVideo = true
            }else{
               self.freeVideo = false
            }
    }
}
