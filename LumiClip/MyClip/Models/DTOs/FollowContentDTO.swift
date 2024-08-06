


//
//  FollowContentDTO.swift
//  MyClip
//
//  Created by Os on 9/26/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON

class FollowContentDTO: NSObject {
    var channelFollow: GroupDTO
    var channelHot: GroupDTO
    
    init(_ json: JSON) {
        channelFollow       = GroupDTO(json["channel_follow"])
        channelHot          = GroupDTO(json["channel_hot"])
    }
}
