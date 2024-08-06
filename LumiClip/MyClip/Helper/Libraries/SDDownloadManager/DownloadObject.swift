//
//  DownloadObject.swift
//  MyClip
//
//  Created by Admin on 11/25/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import RealmSwift

class DownloadObject: Object {
    @objc dynamic var coverImage: String = ""
    @objc dynamic var desc: String = ""
    @objc dynamic var duration: String = ""
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var playTimes: String = ""
    @objc dynamic var publishedTime: String = ""
    @objc dynamic var type: String = ""
    @objc dynamic var userAvatarImage: String = ""
    @objc dynamic var userId: String = ""
    @objc dynamic var userName: String = ""
    @objc dynamic var link: String = ""
    @objc dynamic var likeCount: String = ""
    @objc dynamic var dislikeCount: String = ""
    @objc dynamic var downloadLink: String = ""
    @objc dynamic var downloadPercent: Double = 0.0
    @objc dynamic var downloadSaveName: String = ""
    @objc dynamic var createdAt: Date = Date.init(timeIntervalSince1970: 0)
    @objc dynamic var updatedAt: Date = Date.init(timeIntervalSince1970: 0)
    @objc dynamic var downloadStatus: String = ""
    
    func initialize(from model: DownloadModel) {
        coverImage = model.coverImage
        desc = model.desc
        duration = model.duration
        id = model.id
        name = model.name
        playTimes = model.playTimes
        publishedTime = model.publishedTime
        type = model.type
        userAvatarImage = model.userAvatarImage
        userId = model.userId
        userName = model.userName
        link = model.link
        likeCount = model.likeCount
        dislikeCount = model.dislikeCount
        downloadLink = model.downloadLink
        downloadPercent = model.downloadPercent
        downloadSaveName = model.downloadSaveName
        createdAt = model.createdAt
        updatedAt = model.updatedAt
        downloadStatus = model.downloadStatus.rawValue
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
