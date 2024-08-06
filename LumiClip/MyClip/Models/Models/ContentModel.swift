//
//  ContentModel.swift
//  MyClip
//
//  Created by Os on 8/28/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

@objcMembers
class ContentModel: NSObject {
    var coverImage: String
    var desc: String
    var duration: String
    var durationPercent: Double
    var id: String
    var name: String
    var fullName: String
    var play_times: String
    var publishedTime: String
    var type: String
    var userAvatarImage: String
    var userId: String
    var userName: String
    var fullUserName: String
    var link: String
    var reason: String
    var status: VideoState
    var feedbackRejectReason: String
    var feedbackStatus: String
    var animatedImage: String
    var displayAnimation: Bool = false
    var price_play: String
    
    /////for search v2/////
    var published_time : String
    var channel_id : String
    var channel_name : String
    var num_video : String
    var num_follow : String
   var linkSocial : String
   var freeVideo : Bool
   var canComment : Bool
    init(_ dto: ContentDTO) {
        coverImage = dto.coverImage
        desc = dto.desc
        duration = dto.duration
        durationPercent = dto.durationPercent/100.0
        id = dto.id
        name = dto.name
        fullName = dto.fullName
        play_times = dto.play_times
        publishedTime = dto.publishedTime
        type = dto.type
        userAvatarImage = dto.userAvatarImage
        userId = dto.userId
        userName = dto.userName
        fullUserName = dto.fullUserName
        link = dto.link
        reason = dto.reason
        if dto.status == VideoState.pending.rawValue {
            self.status = .pending
        } else if dto.status == VideoState.approved.rawValue {
            self.status = .approved
        } else if dto.status == VideoState.refuse.rawValue{
            self.status = .refuse
        } else {
            self.status = .none
        }
        self.canComment = dto.canComment
        feedbackStatus = dto.feedback_status
        feedbackRejectReason = dto.feedback_reject_reason
        animatedImage = dto.animatedImage
       price_play = dto.price_play
       
        /////for search v2/////
        published_time = dto.published_time
        channel_id = dto.channel_id
        channel_name = dto.channel_name
        num_video = dto.num_video
        num_follow = dto.num_follow
      linkSocial = dto.linkSocial
      freeVideo = dto.freeVideo
    }
   init(model : CommentModelDisplay) {
      coverImage = ""
      desc = ""
      duration = ""
      durationPercent = 0
      self.id = model.id
      name = ""
      fullName = ""
      play_times = ""
      publishedTime = ""
      type = ""
      userAvatarImage = ""
      userId = ""
      userName = ""
      fullUserName = ""
      link = ""
      reason = ""
      status = .none
      feedbackStatus = ""
      feedbackRejectReason = ""
      animatedImage = ""
      price_play = ""
      
      /////for search v2/////
      published_time = ""
      channel_id = ""
      channel_name = ""
      num_video = ""
      num_follow = ""
      linkSocial = ""
      freeVideo = false
     canComment = false
   }
    init(id: String) {
        coverImage = ""
        desc = ""
        duration = ""
        durationPercent = 0
        self.id = id
        name = ""
        fullName = ""
        play_times = ""
        publishedTime = ""
        type = ""
        userAvatarImage = ""
        userId = ""
        userName = ""
        fullUserName = ""
        link = ""
        reason = ""
        status = .none
        feedbackStatus = ""
        feedbackRejectReason = ""
        animatedImage = ""
        price_play = ""
        
        /////for search v2/////
        published_time = ""
        channel_id = ""
        channel_name = ""
        num_video = ""
        num_follow = ""
        linkSocial = ""
        freeVideo = false
      canComment = false
    }

    init(download model: DownloadModel) {
        coverImage = model.coverImage
        desc = model.desc
        duration = model.duration
        durationPercent = 0.0
        id = model.id
        name = model.name
        fullName = ""
        play_times = model.playTimes
        publishedTime = model.publishedTime
        type = model.type
        userAvatarImage = model.userAvatarImage
        userId = model.userId
        userName = model.userName
        fullUserName = ""
        link = model.link
        status = .pending
        reason = ""
        feedbackStatus = ""
        feedbackRejectReason = ""
        animatedImage = ""
        price_play = ""
      canComment = false
        /////for search v2/////
        published_time = ""
        channel_id = ""
        channel_name = ""
        num_video = ""
        num_follow = ""
        linkSocial = ""
        freeVideo = false
    }
}
