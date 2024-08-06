//
//  CategoryDTO.swift
//  MyClip
//
//  Created by Manh Hoang Xuan on 7/25/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON

class CategoryDTO: NSObject {
    var id: String
    var name: String
    var desc: String
    var coverImage: String
    var avatarImage: String
    var avatarImageHX: String
    var type: String
    var playTimes: String
    var isEvent: Int
    
    init(_ json: JSON) {
        id = json["id"].exists() ? json["id"].stringValue : json["channel_id"].stringValue
        name = json["name"].exists() ? json["name"].stringValue : json["channel_name"].stringValue
        desc = json["description"].stringValue
        coverImage = json["coverImage"].stringValue
        avatarImage = json["avatarImage"].stringValue
        avatarImageHX = json["avatarImageHX"].stringValue
        type = json["type"].stringValue
        playTimes = json["play_times"].stringValue
        isEvent = json["is_event"].intValue
    }
}
