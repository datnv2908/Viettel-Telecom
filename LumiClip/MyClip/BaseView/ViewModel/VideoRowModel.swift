//
//  VideoRowModel.swift
//  MyClip
//
//  Created by Huy Nguyen on 8/18/17.
//  Copyright © 2017 GEM. All rights reserved.
//

import Foundation
struct VideoRowModel: PBaseRowModel {
    var title: String
    var desc: String
    var image: String
    var avatarImage: String
    var postedBy: String
    var viewCount: String
    var postedAt: String
    var identifier: String
    var durationPercent: Double
    var duration: String
    var objectID: String
    var reason: String
    var videoState: VideoState
    var downloadStatus: DownloadStatus = .new
    var downloadPercent: String = ""
    var isSelected: Bool = false
    var feedbackRejectReason: String
    var feedbackStatus: String
    var animatedImage: String
    var freeVideo: Bool
    init(video: ContentModel, identifier: String = VideoTableViewCell.nibName()) {
        self.objectID = video.id
        self.title = video.name
        self.desc = video.desc
        self.image = video.coverImage
        self.identifier = identifier
        self.viewCount = "\(video.play_times) \(String.luot_xem.lowercased())"
        self.postedAt = video.publishedTime
        self.postedBy = video.userName
        self.durationPercent = video.durationPercent
        self.duration = video.duration
        avatarImage = video.userAvatarImage
        self.reason = video.reason
        self.videoState = video.status
        self.feedbackStatus = video.feedbackStatus
        self.feedbackRejectReason = video.feedbackRejectReason
        self.animatedImage = video.animatedImage
        self.freeVideo = video.freeVideo
    }
    
    init(model: DownloadModel, identifier: String = VideoTableViewCell.nibName()) {
        self.identifier = identifier
        self.objectID = model.id
        self.title = model.name
        self.desc = model.desc
        self.image = model.coverImage
        self.viewCount = "\(model.playTimes) \(String.luot_xem.lowercased())"
        self.postedAt = model.publishedTime
        self.postedBy = model.userName
        self.durationPercent = 0.0
        self.duration = model.duration
        avatarImage = model.userAvatarImage
        self.downloadStatus = model.downloadStatus
        self.downloadPercent = "\(String.dang_tai_xuong)... \(Int(model.downloadPercent*100))%"
        videoState = .approved
        self.reason = ""
        self.feedbackStatus = ""
        self.feedbackRejectReason = ""
        self.animatedImage = ""
        self.freeVideo = false
    }
}
