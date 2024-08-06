//
//  CommentModelDisplay.swift
//  MeuClip
//
//  Created by mac on 23/10/2021.
//  Copyright © 2021 Huy Nguyen. All rights reserved.
//

import Foundation
class CommentModelDisplay{
       var id, name, slug: String
       var published_time: String
       var play_times: String
       var comment_count: Bool
       var channel_id: String
       var user_id: String?
       var coverImage: String
       var listComment = [CommentDisPlay]()
      
   
   
   init(model : CommentModelDisplayDTO) {
      self.id = model.id
      self.name = model.name
      self.slug = model.slug
      self.published_time = model.published_time
      self.play_times = model.play_times
      self.comment_count  = model.comment_count
      self.channel_id = model.channel_id
      self.user_id  = model.user_id
      self.coverImage = model.coverImage
      for item in model.listComment {
         let model = CommentDisPlay(model: item)
         self.listComment.append(model)
      }
   }
   
}
class CommentDisPlay {
   var id, type, comment, parentID: String
   var createdAt, likeCount,disLikeCount: String
   var fullName: String?
   var msisdn, userID: String
   var path, bucket, channelBucket, channelPath: String?
   var childcomment = [CommentDisPlay]()
   var avatarImage : String
   var coverImage : String
   var status : String
   var cell :  UITableViewCell?
   var isLike : Bool
   var isDisLike : Bool
   var createdAtFormat : String
   init(model : CommentDisPlayDTO) {
      self.id = model.id
      self.type = model.type
      self.comment = model.comment
      self.parentID = model.parentID
      self.createdAt = model.createdAt
      self.likeCount = model.likeCount
      self.fullName = model.fullName
      self.msisdn = model.msisdn
      self.userID = model.userID
      self.path = model.path
      self.bucket = model.bucket
      self.channelPath  = model.channelPath
      self.channelBucket = model.channelBucket
      self.avatarImage = model.avatarImage
      self.coverImage = model.coverImage
      self.status = model.status
      for item in model.childcomment {
         let model = CommentDisPlay(model:item)
         self.childcomment.append(model)
      }
      self.isLike = model.isLike
      self.isDisLike = model.isDisLike
      self.disLikeCount = model.disLikeCount
      self.createdAtFormat = model.createdAtFormat
   }
   init(user: MemberModel , commentText:String  ) {
      self.id = ""
      self.comment = commentText
      self.type = ""
      self.parentID = ""
      self.createdAt = ""
      self.likeCount = ""
      self.fullName = user.fullName
      self.msisdn = ""
      self.userID = ""
      self.path = ""
      self.bucket = ""
      self.channelPath  = ""
      self.channelBucket = ""
      self.avatarImage = user.avatarImage
      self.coverImage = ""
      self.status = CommentStatus.approvedComment.getId()
      self.cell = nil
      self.isLike = false
      self.isDisLike = false
      self.disLikeCount = ""
      self.createdAtFormat = ""
   }
}
