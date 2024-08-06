//
//  RowModel.swift
//  MyClip
//
//  Created by Huy Nguyen on 3/14/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation
struct RowModel: PBaseRowModel {
    var objectID: String
    var title: String
    var desc: String
    var image: String
    var identifier: String
    var viewNumber: Int
    var timeUpload: String
    var avatarUrl: String
    var channelName: String
    
    /////for api-v2/////
    var channel_id : String
    var num_video : String
    var num_follow : String
    var isShowAllData : Bool = false
    var freeVideo: Bool
    
    init(title: String, identifier: String) {
        objectID = ""
        self.title = title
        desc = ""
        image = ""
        self.identifier = identifier
        viewNumber = 0
        timeUpload = ""
        avatarUrl = ""
        channel_id = ""
        channelName = ""
        num_video = ""
        freeVideo = false
        num_follow = ""
    }
    
    init(title: String, desc: String, image: String, identifier: String) {
        objectID = ""
        self.title = title
        self.desc = desc
        self.image = image
        self.identifier = identifier
        viewNumber = 0
        timeUpload = ""
        avatarUrl = ""
        channel_id = ""
        channelName = ""
        num_video = ""
        num_follow = ""
      freeVideo = false
    }
    
    init(title: String, desc: String, image: String, identifier: String, thumbImage: String) {
        objectID = ""
        self.title = title
        self.desc = desc
        self.image = image
        self.identifier = identifier
        viewNumber = 0
        timeUpload = ""
        avatarUrl = thumbImage
        channel_id = ""
        channelName = ""
        num_video = ""
        num_follow = ""
      freeVideo = false
    }
    
    init(title: String, desc: String, image: String, identifier: String, timeUpload: String) {
        objectID = ""
        self.title = title
        self.desc = desc
        self.image = image
        self.identifier = identifier
        viewNumber = 0
        self.timeUpload = timeUpload
        avatarUrl = ""
        channel_id = ""
        channelName = ""
        num_video = ""
        num_follow = ""
         freeVideo = false
    }
    init(title: String, desc: String, image: String, identifier: String, timeUpload: String,id: String) {
        objectID = id
        self.title = title
        self.desc = desc
        self.image = image
        self.identifier = identifier
        viewNumber = 0
        self.timeUpload = timeUpload
        avatarUrl = ""
        channel_id = ""
        channelName = ""
        num_video = ""
        num_follow = ""
        freeVideo = false
    }
    
    /////for api search-v2/////
    init(title: String, desc: String, image: String, identifier: String, timeUpload: String,id: String, channel_id:String, channel_name: String, viewNumber: Int, isShowAllData: Bool) {
        objectID = id
        self.title = title
        self.desc = desc
        self.image = image
        self.identifier = identifier
        self.viewNumber = viewNumber
        self.timeUpload = timeUpload
        avatarUrl = ""
        self.channel_id = channel_id
        self.channelName = channel_name
        num_video = ""
        num_follow = ""
        self.isShowAllData = isShowAllData
       freeVideo = false
    }
    
    init(title: String, desc: String, image: String, identifier: String, num_video: String, num_follow: String, isShowAllData: Bool) {
        objectID = ""
        self.title = title
        self.desc = desc
        self.image = image
        self.identifier = identifier
        viewNumber = 0
        timeUpload = ""
        avatarUrl = ""
        channel_id = ""
        channelName = ""
        self.num_video = num_video
        self.num_follow = num_follow
        self.isShowAllData = isShowAllData
        freeVideo = false
    }
}
