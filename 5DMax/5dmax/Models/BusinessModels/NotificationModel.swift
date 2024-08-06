//
//  NotificationModel.swift
//  5dmax
//
//  Created by Os on 4/10/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import Foundation
import DateTools

class NotificationModel: NSObject {
    var id: String
    var userId: String
    var uniqId:String
    var tokenId: Int
    var name: String
    var message: String
    var image: String
    var imageH: String
    var groupId: String
    var type: ContentType = ContentType.film
    var isRead: Bool = false
    var action: NotificationAction = NotificationAction.detail
    var senttime: Date
    var senttimeStr: String = ""
    var localID = ""

    init(_ dto: NotificationDTO) {
        id       = dto.id
        userId   = dto.userId
        uniqId   = dto.uniqId
        tokenId  = (DataManager.getCurrentMemberModel()?.userId)!
        name     = dto.name
        message  = dto.message
        image    = dto.image
        imageH   = dto.imageH
        groupId  = dto.groupId
        type     = ContentType(rawValue: dto.type) ?? .film
        isRead   = false
        action   = NotificationAction(rawValue: dto.action) ?? .message
        senttime = dto.senttime.getDateWithFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
        senttimeStr = dto.senttime
        localID = "\(dto.userId)-\(dto.id)-\(dto.groupId)-\(dto.senttime)"
    }
    
    init(object: NotificationObject) {
        id      = object.id
        userId  = object.userId
        uniqId  = object.uniqId
        tokenId = object.tokenId
        name    = object.name
        message = object.message
        image   = object.image
        imageH  = object.imageH
        groupId = object.groupId
        isRead  = object.isRead
        senttime = object.senttime
        localID = object.localID
        if  object.type == ContentType.category.rawValue {
            type = ContentType.category
        } else if object.type == ContentType.collection.rawValue {
            type = ContentType.collection
        }else {
            type == ContentType.film
        }
        super.init()
    }
}
