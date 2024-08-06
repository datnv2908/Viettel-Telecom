//
//  ChannelModel.swift
//  MyClip
//
//  Created by Os on 9/12/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class ChannelDetailsModel: NSObject {
    var id: String
    var name: String
    var desc: String
    var numFollow: Int
    var numVideo: Int
    var avatarImage: String
    var coverImage: String
    var type: String
    var isFollow: Bool
    var status: Int
    var reason: String
    var mostViewVideo: GroupModel
    var newestVideo: GroupModel
    var notificationType: ChannelNotificationType
    var totalViews : Int
    var isOffical : Bool
    var channels =  [MutilChannelModel]()
   var freeVideo : Bool
    init(_ dto: ChannelDetailsDTO) {
        id = dto.id
        name = dto.name
        desc = dto.desc
        numFollow = dto.numFollow
        numVideo = dto.numVideo
        avatarImage = dto.avatarImage
        coverImage = dto.coverImage
        type = dto.type
        isFollow = dto.isFollow
        status = dto.status
        reason = dto.reason
        mostViewVideo = GroupModel(dto.mostViewVideo)
        newestVideo = GroupModel(dto.newestVideo)
        notificationType = ChannelNotificationType(rawValue: dto.notificationType) ?? .none
        channels = dto.channels
        totalViews = dto.totalViews
        isOffical = dto.isOffical
        freeVideo = dto.freeVideo
    }
}
