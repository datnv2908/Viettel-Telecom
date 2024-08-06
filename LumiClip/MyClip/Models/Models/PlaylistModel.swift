//
//  PlaylistModel.swift
//  MyClip
//
//  Created by Os on 9/12/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class PlaylistModel: NSObject {
    var id: String
    var name: String
    var desc: String
    var coverImage: String
    var avatarImage: String
    var numberVideo: Int
    var type: String
   var isOfficial : Bool
   var pricePlay : String
    init(_ dto: PlaylistDTO) {
        id = dto.id
        name = dto.name
        desc = dto.desc
        coverImage = dto.coverImage
        avatarImage = dto.avatarImage
        numberVideo = dto.numberVideo
        type = dto.type
        isOfficial = dto.isOfficial
        pricePlay = dto.pricePlay
    }
    
    init(with id: String) {
        self.id = id
        name = ""
        desc = ""
        coverImage = ""
        avatarImage = ""
        numberVideo = 0
        type = ""
        self.isOfficial = false
        pricePlay = ""
    }
}
