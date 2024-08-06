//
//  PointModel.swift
//  MyClip
//
//  Created by Manh Hoang Xuan on 5/28/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import Foundation
class PointModel: NSObject {
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
    init(_ dto: PointDTO) {
        totalPoint  = dto.totalPoint
        registerPoint   = dto.registerPoint
        likeFanPoint  = dto.likeFanPoint
        uploadPoint = dto.uploadPoint
        watchPoint  = dto.watchPoint
        commentPoint = dto.commentPoint
        dislikePoint = dto.dislikePoint
        likePoint = dto.likePoint
        followPoint = dto.followPoint
        sharePoint = dto.sharePoint
    }
}
