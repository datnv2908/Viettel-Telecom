//
//  NotifyModel.swift
//  5dmax
//
//  Created by Huy Nguyen on 4/26/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation
import SwiftyJSON

struct NotifyModel {
    var parentId: String
    var partId: String
    var message: String
    var contentType: ContentType
    init(_ userInfo: [AnyHashable: Any]) {
        let jsonData = try! JSONSerialization.data(withJSONObject: userInfo, options: .prettyPrinted)
        let json = try! JSON(data: jsonData)
        parentId = json["group_id"].stringValue
        partId = json["id"].stringValue
        contentType = ContentType(rawValue: json["type"].stringValue) ?? .film
        message = json["aps"]["alert"].stringValue
    }
}
