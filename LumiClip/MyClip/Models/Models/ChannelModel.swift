//
//  ChannelModel.swift
//  MyClip
//
//  Created by Huy Nguyen on 9/22/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class ChannelModel: NSObject {
    var id: String
    var name: String
    var avatarImage: String
    var coverImage: String
    var num_follow: Int
    var num_video: Int
    var desc: String
    var isFollow: Bool
    var notificationType: ChannelNotificationType
   var view_Count : Int
   var isMyChannel : Bool = false
   var channelID : String
   var isOffical : Bool
   var freeVideo : Bool
    init(_ dto: ChannelDTO) {
        id = dto.id
        name = dto.name
        avatarImage = dto.avatarImage
        coverImage = dto.coverImage
        num_follow = dto.num_follow
        num_video = dto.num_video
        desc = dto.desc
        isFollow = dto.isFollow
        notificationType = ChannelNotificationType(rawValue: dto.notificationType) ?? .none
       view_Count = 0
       isMyChannel = false
       channelID = dto.channelId
       isOffical = dto.isOffical
       freeVideo = dto.freeVideo
    }
   init(_ dtoModel : ChannelDetailsModel) {
       self.id = dtoModel.id
       self.name = dtoModel.name
       self.avatarImage = dtoModel.avatarImage
       self.coverImage = dtoModel.coverImage
       self.num_follow = dtoModel.numFollow
       self.num_video = dtoModel.numVideo
       self.desc = dtoModel.desc
       self.isFollow = dtoModel.isFollow
       self.notificationType = dtoModel.notificationType
       self.num_follow = dtoModel.numFollow
       self.num_video = dtoModel.numVideo
       self.view_Count = dtoModel.totalViews
       self.channelID = dtoModel.id
       self.isOffical = dtoModel.isOffical
      self.freeVideo  = dtoModel.freeVideo
   }
   init(id: String, name: String = "", desc: String = "", numFollow :Int, numVideo : Int ,viewCount : Int) {
       self.id = id
       self.name = name
       avatarImage = ""
       coverImage = ""
       num_follow = numFollow
       num_video = numVideo
       self.desc = desc
       isFollow = false
       notificationType = .none
       self.view_Count = viewCount
       isMyChannel = false
       self.channelID = id
       isOffical = false
       freeVideo = false
   }
}
