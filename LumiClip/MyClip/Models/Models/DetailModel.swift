//
//  DetailModel.swift
//  MyClip
//
//  Created by Os on 9/20/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class DetailModel: NSObject {
    var id: String
    var name: String
    var desc: String
    var coverImage: String
    var watchTime: Double
    var type: String
    var likeCount: String
    var dislikeCount: String
    var playTimes: String
    var suggestPackageId: String
    var likeStatus: LikeStatus
    var link: String
    var duration: String
    var publishedTime: String
    var showTimes: TimeInterval
    var previewImage: String
    var showDate: Date
    var owner: ChannelModel
   var linkSocial: String
   var freeVideo : Bool
   var canComment : Bool
    init(_ dto: DetailDTO) {
        id = dto.id
        name = dto.name
        desc = dto.desc
        coverImage = dto.coverImage
        watchTime = dto.watchTime
        type = dto.type
        likeCount = dto.likeCount
        dislikeCount = dto.dislikeCount
        playTimes = dto.playTimes
        suggestPackageId = dto.suggestPackageId
        likeStatus = LikeStatus(rawValue: dto.isFavourite) ?? .none
        link = dto.link
        duration = dto.duration
        publishedTime = dto.publishedTime
        showTimes = dto.showTimes
        previewImage = dto.previewImage
        showDate = Date(timeIntervalSinceNow: showTimes)
        owner = ChannelModel(dto.owner)
        linkSocial = dto.linkSocial
      freeVideo = dto.freeVideo
      canComment = dto.canComment
    }

    init(download model: DownloadModel) {
        id = model.id
        name = model.name
        desc = model.desc
        coverImage = model.coverImage
        watchTime = 0
        type = model.type
        likeCount = model.likeCount
        dislikeCount = model.dislikeCount
        playTimes = model.playTimes
        suggestPackageId = ""
        likeStatus = .none
        link = model.link
        duration = model.duration
        publishedTime = model.publishedTime
        showTimes = 0
        showDate = Date(timeIntervalSinceNow: showTimes)
        previewImage = ""
        owner = ChannelModel(id: model.userId, name: model.userName,numFollow: 0, numVideo: 0, viewCount: 0)
        owner.avatarImage = model.userAvatarImage
        linkSocial = ""
        freeVideo = false
      canComment = false
    }
    
    init(from content: ContentModel) {
        id = content.id
        name = content.name
        desc = content.desc
        coverImage = content.coverImage
        watchTime = 0
        type = content.type
        likeCount = ""
        dislikeCount = ""
        playTimes = content.play_times
        suggestPackageId = ""
        likeStatus = .none
        link = content.link
        duration = content.duration
        publishedTime = content.publishedTime
        showTimes = 0
        previewImage = ""
        showDate = Date(timeIntervalSinceNow: showTimes)
        owner = ChannelModel(id: content.userId, name: content.userName,numFollow : 0 , numVideo: 0, viewCount: 0 )
        linkSocial = ""
      freeVideo = content.freeVideo
      canComment = false
    }
}














