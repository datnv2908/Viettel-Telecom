//
//  CommentDisplayModel.swift
//  MeuClip
//
//  Created by mac on 22/10/2021.
//  Copyright © 2021 Huy Nguyen. All rights reserved.
//

import Foundation
import SwiftyJSON


class CommentModelDisplayDTO: NSObject {
       var id, name, slug: String
   var published_time: String
   var play_times: String
   var comment_count: Bool
   var channel_id: String
   var user_id: String
   var coverImage: String
   var listComment = [CommentDisPlayDTO]()
   init(json : JSON) {
      self.id = json["id"].stringValue
      self.name = json["name"].stringValue
      self.slug = json["slug"].stringValue
      self.published_time  = json["published_time"].stringValue
      self.play_times  = json["play_times"].stringValue
      self.comment_count  = json["comment_count"].boolValue
      self.channel_id  = json["channel_id"].stringValue
      self.user_id  = json["user_id"].stringValue
      self.coverImage = json["coverImage"].stringValue
      for item in  json["list_comment"].arrayValue {
         let model = CommentDisPlayDTO(json: item)
         self.listComment.append(model)
      }
      
   }
   
}
class CommentDisPlayDTO: NSObject {
   
   var id, type, comment, parentID: String
   var createdAt, likeCount,disLikeCount: String
   var fullName: String?
   var msisdn, userID: String
   var path, bucket, channelBucket, channelPath: String?
   var childcomment = [CommentDisPlayDTO]()
   var avatarImage : String
   var coverImage : String
   var status : String
   var isLike : Bool
   var isDisLike : Bool = false
   var createdAtFormat : String
   init(json : JSON) {
      self.id = json["id"].stringValue
      self.type = json["type"].stringValue
      self.comment = json["comment"].stringValue
      self.parentID = json["parent_id"].stringValue
      self.createdAt = json["created_at"].stringValue
      self.likeCount = json ["like_count"].stringValue
      self.fullName = json["full_name"].stringValue
      self.msisdn = json["msisdn"].stringValue
      self.userID = json["user_id"].stringValue
      self.path = json["path"].stringValue
      self.bucket = json["bucket"].stringValue
      self.channelBucket = json["channel_bucket"].stringValue
      self.channelPath = json["channel_path"].stringValue
      self.avatarImage = json["avatarImage"].stringValue
      self.coverImage = json["coverImage"].stringValue
      for item in  json["children"].arrayValue {
         let model = CommentDisPlayDTO(json: item)
         self.childcomment.append(model)
      }
      self.disLikeCount = json["dislike_count"].stringValue
      self.status = json["status"].stringValue
      self.isLike = json["is_like"].boolValue
      self.isDisLike = json["isDislike"].boolValue
      self.createdAtFormat = json["created_at_format"].stringValue
      
   }
}
