//
//  ChannelDTO.swift
//  MyClip
//
//  Created by Os on 9/12/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON

class ChannelDetailsDTO: NSObject {
    var id: String
    var name: String
    var desc: String
    var numFollow: Int
    var numVideo: Int
    var avatarImage: String
    var coverImage: String
    var type: String
    var isFollow: Bool
    var mostViewVideo: GroupDTO
    var newestVideo: GroupDTO
    var notificationType: Int
    var status: Int
    var reason: String
   var isOffical : Bool
   var totalViews : Int
   var channels =  [MutilChannelModel]()
   var freeVideo : Bool
    init(_ json: JSON) {
        id            = json["detail"]["id"].stringValue
        name          = json["detail"]["name"].stringValue
        desc          = json["detail"]["description"].stringValue
        numFollow     = json["detail"]["num_follow"].intValue
        numVideo      = json["detail"]["num_video"].intValue
        avatarImage   = json["detail"]["avatarImage"].stringValue
        coverImage    = json["detail"]["coverImage"].stringValue
        type          = json["detail"]["type"].stringValue
        isFollow      = json["detail"]["isFollow"].boolValue
        status        = json["detail"]["status"].intValue
        reason        = json["detail"]["reason"].stringValue
        mostViewVideo = GroupDTO(json["most_view_video"])
        newestVideo   = GroupDTO(json["newest_video"])
        notificationType = json["detail"]["notification_type"].intValue
        let channel = json["channel"].arrayValue
      for  i in channel {
          channels.append(MutilChannelModel(i))
      }
      totalViews  = json["detail"]["totalViews"].intValue
      isOffical  = json["detail"]["official"].boolValue
      if json["price_play"].stringValue ==  "0" {
         self.freeVideo = true
      }else{
         self.freeVideo = false
      }
    }
}
