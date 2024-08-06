//
//  NotificationObject.swift
//  5dmax
//
//  Created by admin on 8/29/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import UIKit
import RealmSwift

class NotificationObject: Object {
    
    @objc dynamic var id: String = ""
    @objc dynamic var userId = ""
    @objc dynamic var uniqId = ""
    @objc dynamic var tokenId: Int = 0
    @objc dynamic var name = ""
    @objc dynamic var message = ""
    @objc dynamic var image = ""
    @objc dynamic var imageH = ""
    @objc dynamic var groupId = ""
    @objc dynamic var isRead: Bool = false
    @objc dynamic var senttime: Date = Date.init(timeIntervalSince1970: 0)
    @objc dynamic var type = ""
    @objc dynamic var action = ""
    @objc dynamic var localID = ""
    
    func initalize(from model: NotificationModel) {
        id          = model.id
        userId      = model.userId
        uniqId      = model.uniqId
        tokenId     = model.tokenId
        name        = model.name
        message     = model.message
        image       = model.image
        imageH      = model.imageH
        groupId     = model.groupId
        isRead      = model.isRead
        senttime    = model.senttime
        type        = model.type.rawValue
        action      = model.type.rawValue
        localID     = model.localID
    }
    
    override static func primaryKey() -> String? {
        return "localID"
    }
}
