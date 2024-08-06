//
//  ChannelDetailAboutViewModel.swift
//  MyClip
//
//  Created by Huy Nguyen on 9/26/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation
struct ChannelDetailAboutViewModel {
    var channelModel: ChannelModel
    init(_ model: ChannelModel) {
        channelModel = model
        about = model.desc
        videoCount = model.num_video
        followCount = model.num_follow
      viewCount = model.view_Count
    }
    var about: String
    var videoCount: Int
    var followCount: Int
   var viewCount: Int
}
