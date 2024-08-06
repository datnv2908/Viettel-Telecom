
//
//  GroupDTO.swift
//  MyClip
//
//  Created by Os on 9/12/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON

class GroupDTO: NSObject {
    var id: String
    var name: String
    var type: String
    var avatarImage: String
    var banners: [BannerDTO]
    var videos: [ContentDTO]
    var playlists: [PlaylistDTO]
    var topics: [TopicDTO]
    var channels: [ChannelDTO]
    var groupType: GroupType
    var desc: String
    var fullUserName: String
    
    init(_ json: JSON) {
        id              = json["id"].stringValue
        name            = json["name"].stringValue
        type            = json["type"].stringValue
        avatarImage     = json["avatarImage"].stringValue
        banners = []
        videos = []
        playlists = []
        topics = []
        channels = []
        groupType = .none
        desc = json["description"].stringValue
        fullUserName = json["fullUserName"].stringValue
        switch type {
        case GroupType.relate.rawValue:
            for (_, subJson) in json["content"] {
                let dto = ContentDTO(subJson)
                videos.append(dto)
            }
            groupType = .relate
        case GroupType.channel.rawValue:
            for (_, subJson) in json["content"] {
                let dto = ChannelDTO(subJson)
                channels.append(dto)
            }
            groupType = .channel
        case GroupType.video.rawValue:
            for (_, subJson) in json["content"] {
                let dto = ContentDTO(subJson)
                videos.append(dto)
            }
            groupType = .video
        default:
            for (_, subJson) in json["content"] {
                let dto = ContentDTO(subJson)
                videos.append(dto)
            }
            groupType = .none
        }
    }
}
