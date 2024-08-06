//
//  FollowContentModel.swift
//  MyClip
//
//  Created by Os on 9/26/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class FollowContentModel: NSObject {
    var channelFollow: GroupModel
    var channelHot: GroupModel
    
    init(_ dto: FollowContentDTO) {
        channelFollow = GroupModel(dto.channelFollow)
        channelHot = GroupModel(dto.channelHot)
    }
}
