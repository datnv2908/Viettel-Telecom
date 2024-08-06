//
//  NotificationModel.swift
//  MyClip
//
//  Created by hnc on 10/23/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import DateToolsSwift

class NotificationModel: NSObject {
   var id: String
   var aps: String
   var groupId: String
   var sentTime: Date?
   var sentTimeFormat: String
   var type: NotificationType
   var recordId: String
   var isRead: Bool
   var coverImage: String
   var avatarImage: String
   var link: String
   var channelId: String
   var channelName: String
   var freeVideo : Bool
   var videoId : String
   var lastComment : String
   init(_ dto: NotificationDTO) {
      id = dto.id
      aps = dto.aps
      groupId = dto.groupId
      sentTime = dto.sentTime.getDateWithFormat(Constants.dateFormatter)
      sentTimeFormat = dto.sentTimeFormat
      type = NotificationType(rawValue: dto.type) ?? .video
      recordId = dto.recordId
      isRead = dto.isRead
      coverImage = dto.coverImage
      avatarImage = dto.avatarImage
      link = dto.link
      channelId = dto.channelId
      channelName = dto.channelName
      freeVideo = dto.freeVideo
      videoId = dto.videoId
      lastComment = dto.lastComment
   }
}
