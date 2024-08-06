


//
//  GroupModel.swift
//  MyClip
//
//  Created by Os on 9/12/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class GroupModel: NSObject {
    var id: String
    var name: String
    var type: String
    var avatarImage: String
    var banners: [BannerModel]
    var videos: [ContentModel]
    var playlists: [PlaylistModel]
    var topics: [TopicModel]
    var channels: [ChannelModel]
    var groupType: GroupType
    var desc: String
    var fullUserName: String

    override init() {
        id = ""
        name = ""
        type = ""
        avatarImage = ""
        banners = [BannerModel]()
        videos = [ContentModel]()
        playlists = [PlaylistModel]()
        topics = [TopicModel]()
        channels = [ChannelModel]()
        groupType = .video
        desc = ""
        fullUserName = ""
    }

    init(_ dto: GroupDTO) {
        self.id = dto.id
        name = dto.name
        type = dto.type
        avatarImage = dto.avatarImage
        groupType = dto.groupType
        desc = dto.desc
        fullUserName = dto.fullUserName
        banners = []
        for subDTO in dto.banners {
            banners.append(BannerModel(subDTO))
        }
        videos = []
        for subDTO in dto.videos {
            videos.append(ContentModel(subDTO))
        }
        playlists = []
        for subDTO in dto.playlists {
            playlists.append(PlaylistModel(subDTO))
        }
        topics = []
        for subDTO in dto.topics {
            topics.append(TopicModel(subDTO))
        }
        channels = []
        for subDTO in dto.channels {
            channels.append(ChannelModel(subDTO))
        }
    }
}
