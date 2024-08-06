
//
//  HomeModel.swift
//  MyClip
//
//  Created by Os on 9/12/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class HomeModel: NSObject {
    var channels: [ChannelModel]
    var videos: [ContentModel]
    
    override init() {
        channels = [ChannelModel]()
        videos = [ContentModel]()
    }
    
    init(channels: [ChannelModel], videos:[ContentModel] ) {
        self.channels = channels
        self.videos = videos
    }
}
