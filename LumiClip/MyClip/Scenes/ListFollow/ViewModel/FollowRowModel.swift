


//
//  FollowRowModel.swift
//  MyClip
//
//  Created by Os on 9/13/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

struct FollowRowModel: PBaseRowModel {
    var title: String
    var desc: String
    var image: String
    var identifier: String
    var objectID: String
    var followCount: String
    var isFollow: Bool
   var freeVideo: Bool
    init(_ model: ChannelModel, _ isOwner: Bool) {
        title = model.name
        desc = "\(model.num_video) \(String.videos.lowercased())"
        image = model.avatarImage
        if(isOwner){
            identifier = MyFollowTableViewCell.nibName()
        }else{
            identifier = FollowTableViewCell.nibName()
        }
        objectID = model.id
        followCount = "\(model.num_follow) \(String.theo_doi.lowercased())"
        isFollow = model.isFollow
        freeVideo = model.freeVideo
    }
}
