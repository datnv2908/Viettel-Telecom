//
//  RemoteNotificationModel.swift
//  MyClip
//
//  Created by Huy Nguyen on 8/31/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation
import SwiftyJSON

struct RemoteNotificationModel {
    var notificationType: NotificationType
    var id: String
    var groupId: String
    var message: String
    init(_ userInfo: [AnyHashable: Any]) {
        let jsonData = try! JSONSerialization.data(withJSONObject: userInfo, options: .prettyPrinted)
        let json = try! JSON(data: jsonData)
        id = json["id"].stringValue
        groupId = json["group_id"].stringValue
        notificationType = NotificationType(rawValue: json["type"].stringValue) ?? .video
        message = json["aps"]["alert"].stringValue
    }
}
