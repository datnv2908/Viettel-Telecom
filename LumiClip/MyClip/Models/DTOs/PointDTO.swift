//
//  PointDTO.swift
//  MyClip
//
//  Created by Manh Hoang Xuan on 5/28/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import Foundation
import SwiftyJSON

class PointDTO : NSObject {
    var totalPoint: Int
    var registerPoint: Int
    var likeFanPoint: Int
    var uploadPoint: Int
    var watchPoint: Int
    var commentPoint: Int
    var dislikePoint: Int
    var likePoint: Int
    var followPoint: Int
    var sharePoint: Int
    init(_ json: JSON) {
        totalPoint      = json["total_point"].intValue
        registerPoint            = json["register_point"].intValue
        likeFanPoint        = json["like_fanpage_point"].intValue
        uploadPoint = json["upload_point"].intValue
        watchPoint              = json["watch_point"].intValue
        commentPoint            = json["comment_point"].intValue
        dislikePoint      = json["dislike_point"].intValue
        likePoint   = json["like_point"].intValue
        followPoint            = json["follow_point"].intValue
        sharePoint = json["share_point"].intValue
    }
}
