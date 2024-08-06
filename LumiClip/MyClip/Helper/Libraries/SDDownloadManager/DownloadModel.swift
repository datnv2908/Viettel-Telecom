//
//  DownloadModel.swift
//  MyClip
//
//  Created by hnc on 12/19/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class DownloadModel: NSObject {
    var coverImage: String
    var desc: String
    var duration: String
    var id: String
    var name: String
    var playTimes: String
    var publishedTime: String
    var type: String
    var userAvatarImage: String
    var userId: String
    var userName: String
    var link: String
    var likeCount: String
    var dislikeCount: String
    var downloadLink: String
    var downloadPercent: Double
    var downloadSaveName: String
    var createdAt: Date
    var updatedAt: Date
    var downloadStatus: DownloadStatus {
        didSet {
            switch downloadStatus {
            case .new, .cancelled, .error:
                downloadPercent = 0.0
            default:
                break
            }
        }
    }

    init(from video: DetailModel) {
        coverImage = video.coverImage
        desc = video.desc
        duration = video.duration
        id = video.id
        name = video.name
        playTimes = video.playTimes
        publishedTime = video.publishedTime
        type = video.type
        userAvatarImage = video.owner.avatarImage
        userId = video.owner.id
        userName = video.owner.name
        link = video.link
        likeCount = video.likeCount
        dislikeCount = video.dislikeCount
        downloadLink = ""
        downloadStatus = .new
        downloadPercent = 0.0
        downloadSaveName = "\(id).mp4"
        createdAt = Date()
        updatedAt = Date()
    }

    init(withLolcal object: DownloadObject) {
        coverImage = object.coverImage
        desc = object.desc
        duration = object.duration
        id = object.id
        name = object.name
        playTimes = object.playTimes
        publishedTime = object.publishedTime
        type = object.type
        userAvatarImage = object.userAvatarImage
        userId = object.userId
        userName = object.userName
        link = object.link
        likeCount = object.likeCount
        dislikeCount = object.dislikeCount
        downloadLink = object.downloadLink
        downloadPercent = object.downloadPercent
        downloadSaveName = object.downloadSaveName
        createdAt = object.createdAt
        updatedAt = object.updatedAt
        downloadStatus = DownloadStatus(rawValue: object.downloadStatus) ?? .downloaded
    }

    func localFilePath() -> String {
        return SDFileUtils.downloadedFilePath(with: downloadSaveName)
    }
}
