//
//  MutilChannelModel.swift
//  UClip
//
//  Created by Toan on 5/17/21.
//  Copyright © 2021 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON
class MutilChannelModel: PBaseRowModel {
   var freeVideo: Bool
   var title: String
   var desc: String
   var image: String
   var identifier: String
   var objectID: String
   var userId: String
   var status: String
   var bucket: String
   var path: String
   var channelBucket: String
   var reason: String
   var createdAt: String
   var updatedAt: String
   var followCount: String
   var viewCount: Int
   var videoCount: Int
   var isOfficial: Bool
   init() {
      title = "1647283"
      desc = "11"
      image = "11"
      identifier = "11"
      objectID = "1647283"
      userId = "11"
      status = "11"
      bucket = "11"
      path = "11"
      channelBucket = "11"
      reason = "11"
      createdAt = "11"
      updatedAt = "11"
      followCount = "11"
      viewCount = 2
      videoCount = 2
      isOfficial = false
      freeVideo = false
   }
   
   init(_ json: JSON) {
      objectID = json["id"].stringValue
      userId = json["user_id"].stringValue
      title = json["full_name"].stringValue
      channelBucket = json["channel_bucket"].stringValue
      path = json["path"].stringValue
      bucket = json["bucket"].stringValue
      image = json["channel_path"].stringValue
      reason = json["reason"].stringValue
      createdAt = json["created_at"].stringValue
      updatedAt = json["updated_at"].stringValue
      followCount = json["follow_count"].stringValue
      viewCount = json["view_count"].intValue
      videoCount = json["video_count"].intValue
      desc = json["description"].stringValue
      status = json["status"].stringValue
      self.identifier = ""
      if json["is_official"].stringValue == "1"  {
         isOfficial = true
      }else{
         isOfficial = false
      }
      if json["price_play"].stringValue == "" {
         self.freeVideo = true
      }else{
         self.freeVideo = false
      }
   }
   init(model : MutilChannelModel) {
      self.userId = model.userId
      self.objectID = model.objectID
      self.status = model.status
      self.title = model.title
      self.bucket = model.bucket
      self.path = model.path
      self.image = model.image
      self.channelBucket = model.channelBucket
      self.reason = model.reason
      self.createdAt = model.createdAt
      self.updatedAt = model.updatedAt
      self.followCount = model.followCount
      self.viewCount = model.viewCount
      self.videoCount = model.videoCount
      self.desc = model.desc
      self.identifier = ""
      isOfficial = model.isOfficial
      freeVideo = model.freeVideo
   }
}
