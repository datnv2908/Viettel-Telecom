//
//  NotificationDTO.swift
//  MyClip
//
//  Created by hnc on 10/23/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON

class NotificationDTO: NSObject {
   var id: String
   var aps: String
   var groupId: String
   var sentTime: String
   var sentTimeFormat: String
   var type: String
   var recordId: String
   var isRead: Bool
   var coverImage: String
   var avatarImage: String
   var link: String
   var channelId: String
   var channelName: String
   var freeVideo : Bool
   var lastComment : String
   var videoId : String
   init(_ json: JSON) {
      id = json["id"].stringValue
      aps = json["aps"]["alert"].stringValue
      groupId = json["group_id"].stringValue
      sentTime = json["sent_time"].stringValue
      sentTimeFormat = json["sent_time_format"].stringValue
      type = json["type"].stringValue
      recordId = json["record_id"].stringValue
      isRead = json["is_read"].boolValue
      coverImage = json["coverImage"].stringValue
      avatarImage = json["avatarImage"].stringValue
      link = json["link"].stringValue
      channelId = json["channel_id"].stringValue
      channelName = json["channel_name"].stringValue
      lastComment = json["last_comment"].stringValue
      videoId = json["video_id"].stringValue
      if json["price_play"].stringValue ==  "0" {
         self.freeVideo = true
      }else{
         self.freeVideo = false
      }
   }
}
