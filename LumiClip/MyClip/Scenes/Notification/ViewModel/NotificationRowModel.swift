//
//  NotificationRowModel.swift
//  MyClip
//
//  Created by hnc on 10/23/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation
import DateToolsSwift

struct NotificationRowModel: PBaseRowModel {
    var title: String
    var desc: String
    var coverImage: String
    var image: String
    var isRead: Bool
    var identifier: String
    var objectID: String
   var freeVideo: Bool
   var idVideo : String
   var idComment : String
   var avatarImage : String
    init(_ model: NotificationModel) {
        title = model.aps
        desc = model.sentTimeFormat
        coverImage = model.coverImage
        image = model.avatarImage
        isRead = model.isRead
        identifier = NotificationTableViewCell.nibName()
        objectID = model.recordId
        freeVideo = model.freeVideo
        idVideo = model.videoId
      idComment = model.lastComment
      avatarImage  = model.avatarImage
    }
}
